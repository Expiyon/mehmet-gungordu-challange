module challenge::arena;

use challenge::hero::Hero;
use sui::event;
use sui::transfer;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {

    // Create an arena object
    let arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: ctx.sender(),
    };
    
    // Emit ArenaCreated event with arena ID and timestamp
    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: ctx.epoch_timestamp_ms(),
    });
    
    // Make it publicly tradeable
    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    
    // Destructure arena to get id, warrior, and owner
    let Arena { id, warrior, owner } = arena;
    
    // Get hero IDs before transfer
    let hero_id = object::id(&hero);
    let warrior_id = object::id(&warrior);
    
    // Compare hero power with warrior power
    if (hero.hero_power() > warrior.hero_power()) {
        // Hero wins: both heroes go to ctx.sender()
        transfer::public_transfer(hero, ctx.sender());
        transfer::public_transfer(warrior, ctx.sender());
        
        // Emit ArenaCompleted event
        event::emit(ArenaCompleted {
            winner_hero_id: hero_id,
            loser_hero_id: warrior_id,
            timestamp: ctx.epoch_timestamp_ms(),
        });
    } else {
        // Warrior wins: both heroes go to arena owner
        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);
        
        // Emit ArenaCompleted event
        event::emit(ArenaCompleted {
            winner_hero_id: warrior_id,
            loser_hero_id: hero_id,
            timestamp: ctx.epoch_timestamp_ms(),
        });
    };
    
    // Delete the arena ID
    object::delete(id);
}