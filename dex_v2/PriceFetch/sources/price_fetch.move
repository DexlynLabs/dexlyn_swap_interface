module dexlyn_price_fetcher::fetch_clmm_price {

    const DEFAULT_DECIMAL: u16 = 18;
    const DEFAULT_DECIMAL_PRECISION_9: u64 = 1_000_000_000;
    const E_INCORRECT_VALUES: u64 = 0;
    const E_POOL_NOT_EXIST: u64 = 1;

    struct Price has drop {
        pool_address: address,
        asset_a_address: address,
        asset_b_address: address,
        value: u256,
        decimal: u16,
        timestamp: u64,
    }

    #[view]
    native public fun get_prices(pool_addresses: vector<address>): vector<Price>;
    #[view]
    native public fun get_price(pool_address: address): Price;
    native public fun extract_price(price: &Price): (address, address, address, u256, u16, u64);
}
