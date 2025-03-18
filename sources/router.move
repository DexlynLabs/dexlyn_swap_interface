module dexlyn_swap::router {
    use dexlyn_swap_lp::lp_coin::LP;
    use supra_framework::coin::Coin;

    /// Register new liquidity pool for `X`/`Y` pair on signer address with `LP` coin.
    ///
    /// Note: X, Y generic coin parameters must be sorted.
    native public fun register_pool<X, Y, Curve>(account: &signer);

    /// Add liquidity to pool `X`/`Y` with rationality checks.
    /// * `coin_x` - coin X to add as liquidity.
    /// * `min_coin_x_val` - minimum amount of coin X to add as liquidity.
    /// * `coin_y` - coin Y to add as liquidity.
    /// * `min_coin_y_val` - minimum amount of coin Y to add as liquidity.
    /// Returns remainders of coins X and Y, and LP coins: `(Coin<X>, Coin<Y>, Coin<LP<X, Y, Curve>>)`.
    ///
    /// Note: X, Y generic coin parameters must be sorted.
    native public fun add_liquidity<X, Y, Curve>(
        coin_x: Coin<X>,
        min_coin_x_val: u64,
        coin_y: Coin<Y>,
        min_coin_y_val: u64,
    ): (Coin<X>, Coin<Y>, Coin<LP<X, Y, Curve>>);

    /// Burn liquidity coins `LP` and get coins `X` and `Y` back.
    /// * `lp_coins` - `LP` coins to burn.
    /// * `min_x_out_val` - minimum amount of `X` coins must be out.
    /// * `min_y_out_val` - minimum amount of `Y` coins must be out.
    /// Returns both `Coin<X>` and `Coin<Y>`: `(Coin<X>, Coin<Y>)`.
    ///
    /// Note: X, Y generic coin parameteres should be sorted.
    native public fun remove_liquidity<X, Y, Curve>(
        lp_coins: Coin<LP<X, Y, Curve>>,
        min_x_out_val: u64,
        min_y_out_val: u64,
    ): (Coin<X>, Coin<Y>);

    /// Swap exact amount of coin `X` for coin `Y`.
    /// * `coin_in` - coin X to swap.
    /// * `coin_out_min_val` - minimum amount of coin Y to get out.
    /// Returns `Coin<Y>`.
    native public fun swap_exact_coin_for_coin<X, Y, Curve>(
        coin_in: Coin<X>,
        coin_out_min_val: u64,
    ): Coin<Y>;

    /// Swap max coin amount `X` for exact coin `Y`.
    /// * `coin_max_in` - maximum amount of coin X to swap to get `coin_out_val` of coins Y.
    /// * `coin_out_val` - exact amount of coin Y to get.
    /// Returns remainder of `coin_max_in` as `Coin<X>` and `Coin<Y>`: `(Coin<X>, Coin<Y>)`.
    native public fun swap_coin_for_exact_coin<X, Y, Curve>(
        coin_max_in: Coin<X>,
        coin_out_val: u64,
    ): (Coin<X>, Coin<Y>);

    /// Swap coin `X` for coin `Y` WITHOUT CHECKING input and output amount.
    /// So use the following function only on your own risk.
    /// * `coin_in` - coin X to swap.
    /// * `coin_out_val` - amount of coin Y to get out.
    /// Returns `Coin<Y>`.
    native public fun swap_coin_for_coin_unchecked<X, Y, Curve>(
        coin_in: Coin<X>,
        coin_out_val: u64,
    ): Coin<Y>;

    // Getters.

    #[view]
    /// Get decimals scales for stable curve, for uncorrelated curve would return zeros.
    /// Returns `X` and `Y` coins decimals scales.
    native public fun get_decimals_scales<X, Y, Curve>(): (u64, u64);

    #[view]
    /// Get current cumulative prices in liquidity pool `X`/`Y`.
    /// Returns (X price, Y price, block_timestamp).
    native public fun get_cumulative_prices<X, Y, Curve>(): (u128, u128, u64);

    #[view]
    /// Get reserves of liquidity pool (`X` and `Y`).
    /// Returns current reserves (`X`, `Y`).
    native public fun get_reserves_size<X, Y, Curve>(): (u64, u64);

    #[view]
    /// Get fee for specific pool together with denominator (numerator, denominator).
    native public fun get_fees_config<X, Y, Curve>(): (u64, u64);

    #[view]
    /// Get fee for specific pool.
    native public fun get_fee<X, Y, Curve>(): u64;

    #[view]
    /// Get DAO fee for specific pool together with denominator (numerator, denominator).
    native public fun get_dao_fees_config<X, Y, Curve>(): (u64, u64);

    #[view]
    /// Get DAO fee for specific pool.
    native public fun get_dao_fee<X, Y, Curve>(): u64;

    #[view]
    /// Check swap for pair `X` and `Y` exists.
    /// If pool exists returns true, otherwise false.
    native public fun is_swap_exists<X, Y, Curve>(): bool;

    #[view]
    /// Calculate optimal amounts of `X`, `Y` coins to add as a new liquidity.
    /// * `x_desired` - provided value of coins `X`.
    /// * `y_desired` - provided value of coins `Y`.
    /// * `x_min` - minimum of coins X expected.
    /// * `y_min` - minimum of coins Y expected.
    /// Returns both `X` and `Y` coins amounts.
    native public fun calc_optimal_coin_values<X, Y, Curve>(
        x_desired: u64,
        y_desired: u64,
        x_min: u64,
        y_min: u64
    ): (u64, u64);

    /// Return amount of liquidity (LP) need for `coin_in`.
    /// * `coin_in` - amount to swap.
    /// * `reserve_in` - reserves of coin to swap.
    /// * `reserve_out` - reserves of coin to get.
    native public fun convert_with_current_price(coin_in: u64, reserve_in: u64, reserve_out: u64): u64;

    #[view]
    /// Convert `LP` coins to `X` and `Y` coins, useful to calculate amount the user recieve after removing liquidity.
    /// * `lp_to_burn_val` - amount of `LP` coins to burn.
    /// Returns both `X` and `Y` coins amounts.
    native public fun get_reserves_for_lp_coins<X, Y, Curve>(
        lp_to_burn_val: u64
    ): (u64, u64);

    #[view]
    /// Get amount out for `amount_in` of X coins (see generic).
    /// So if Coins::USDC is X and Coins::USDT is Y, it will get amount of USDT you will get after swap `amount_x` USDC.
    /// !Important!: This function can eat a lot of gas if you querying it for stable curve pool, so be aware.
    /// We recommend to do implement such kind of logic offchain.
    /// * `amount_x` - amount to swap.
    /// Returns amount of `Y` coins getting after swap.
    native public fun get_amount_out<X, Y, Curve>(amount_in: u64): u64;

    #[view]
    /// Get amount in for `amount_out` of X coins (see generic).
    /// So if Coins::USDT is X and Coins::USDC is Y, you pass how much USDC you want to get and
    /// it returns amount of USDT you have to swap (include fees).
    /// !Important!: This function can eat a lot of gas if you querying it for stable curve pool, so be aware.
    /// We recommend to do implement such kind of logic offchain.
    /// * `amount_x` - amount to swap.
    /// Returns amount of `X` coins needed.
    native public fun get_amount_in<X, Y, Curve>(amount_out: u64): u64;
}
