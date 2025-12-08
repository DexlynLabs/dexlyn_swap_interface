module dexlyn_clmm::utils {
    use std::string::String;
    use aptos_std::comparator;

    #[view]
    /// Compare two addresses
    /// Returns:
    /// - `comparator::Result::Less` if a < b
    /// - `comparator::Result::Equal` if a == b
    /// - `comparator::Result::Greater` if a > b
    native public fun compare_address(a: address, b: address): comparator::Result;

    #[view]
    /// Convert a u64 to a string
    /// Returns the string representation of the number
    native public fun str(num: u64): String;

    #[view]
    /// Compare two coin types
    /// Returns:
    /// - `comparator::Result::Less` if CoinTypeA < CoinTypeB
    /// - `comparator::Result::Equal` if CoinTypeA == CoinTypeB
    /// - `comparator::Result::Greater` if CoinTypeA > CoinTypeB
    native public fun compare_coin<CoinTypeA, CoinTypeB>(): comparator::Result;

    #[view]
    /// Get the address of a coin type
    /// Returns the address of the coin type
    native public fun coin_to_fa_address<CoinType>(): address;
}