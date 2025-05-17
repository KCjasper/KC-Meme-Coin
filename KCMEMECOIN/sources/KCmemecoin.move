module KCmemecoin::kc_coin {
    use std::option;
    use std::string;
    use sui::url::{Self, Url}; 
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    public struct KC_COIN has drop {}

    //Initialize Token Contract
    fun init(witness: KC_COIN, ctx: &mut TxContext) {
        let icon_url = url::new_unsafe_from_bytes(
            b"https://cdn.midjourney.com/b2700cb9-b8a6-4a87-9864-40273acd6f8a/0_0.png"
        );
        
        let icon_option = option::some(icon_url);

        let (treasury_cap, metadata) = coin::create_currency(
            witness,
            9, // decimals
            b"KC", // symbol
            b"KC Meme Coin", // name
            b"A fun meme coin created on Sui", // description
            icon_option, 
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    //mint function
    public entry fun mint(
        treasury: &mut TreasuryCap<KC_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let coin = coin::mint(treasury, amount, ctx);
        transfer::public_transfer(coin, recipient);
    }
    //Show Balance function
    public fun balance(coin: &Coin<KC_COIN>): u64 {
        coin::value(coin)
    }
}
