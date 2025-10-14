/// Marker structures to use in LiquidityPool third generic.
module dexlyn_swap::curves {

    /// For pairs like BTC, Aptos, ETH. x * y = k
    struct Uncorrelated {}

    /// For stablecoins like USDC, USDT. x^3*y + x*y^3 = k
    struct Stable {}
}
