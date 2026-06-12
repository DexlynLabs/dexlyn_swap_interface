module dexlyn_swap::scripts {

    /// Swap exact coin `X` for at least minimum coin `Y`.
    /// * `coin_val` - amount of coins `X` to swap.
    /// * `coin_out_min_val` - minimum expected amount of coins `Y` to get.
    native public entry fun swap<X, Y, Curve>(
        account: &signer,
        coin_val: u64,
        coin_out_min_val: u64,
    );

    /// Swap maximum coin `X` for exact coin `Y`.
    /// * `coin_val_max` - how much of coins `X` can be used to get `Y` coin.
    /// * `coin_out` - how much of coins `Y` should be returned.
    native public entry fun swap_into<X, Y, Curve>(
        account: &signer,
        coin_val_max: u64,
        coin_out: u64,
    );

    /// Swap `coin_in` of X for a `coin_out` of Y.
    /// Does not check optimality of the swap, and fails if the `X` to `Y` price ratio cannot be satisfied.
    /// * `coin_in` - how much of coins `X` to swap.
    /// * `coin_out` - how much of coins `Y` should be returned.
    native public entry fun swap_unchecked<X, Y, Curve>(
        account: &signer,
        coin_in: u64,
        coin_out: u64,
    );
}
