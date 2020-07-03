# Swap TRC10 to TRC20 token
One way swap of TRC10 to TRC20 token.

Before swap you need set exchange rate via "setExchangeRate()", by default rate is 100.
For successful swap owner require to do deposit TRC20 to the contract.

Constructor - 1 arg. set TRC10 id (number), 2 arg. set TRC20 address (string)

### How to swap?

1)  call func. "depositTrc10"
2)  call func. "swap"
3)  call func. "withdrawTrc20:
