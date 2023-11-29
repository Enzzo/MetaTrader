#ifdef MT4

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_SYMBOL_CALC_MODE                                           |
//  +-------------------------------------------------------------------+
enum ENUM_SYMBOL_CALC_MODE{
    SYMBOL_CALC_MODE_FOREX,    
    SYMBOL_CALC_MODE_FUTURES,
    SYMBOL_CALC_MODE_CFD,
    SYMBOL_CALC_MODE_CFDINDEX,
    SYMBOL_CALC_MODE_CFDLEVERAGE,
    SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE,    
    SYMBOL_CALC_MODE_EXCH_STOCKS = 32,
    SYMBOL_CALC_MODE_EXCH_FUTURES = 33,
    SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS = 34,
    SYMBOL_CALC_MODE_EXCH_BONDS = 37,
    SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX = 38,
    SYMBOL_CALC_MODE_EXCH_BONDS_MOEX = 39,
    SYMBOL_CALC_MODE_SERV_COLLATERAL = 64
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_POSITION_TYPE                                              |
//  +-------------------------------------------------------------------+
enum ENUM_POSITION_TYPE{
    POSITION_TYPE_BUY,
    POSITION_TYPE_SELL
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_POSITION_PROPERTY_INTEGER                                  |
//  +-------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_INTEGER{
    POSITION_TICKET,
    POSITION_TIME,
    POSITION_TIME_MSC,
    POSITION_TIME_UPDATE,
    POSITION_TYPE,
    POSITION_MAGIC,
    POSITION_IDENTIFIER,
    POSITION_REASON
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_POSITION_PROPERTY_DOUBLE                                   |
//  +-------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_DOUBLE{
    POSITION_VOLUME = 3,
    POSITION_PRICE_OPEN = 4,
    POSITION_PRICE_CURRENT = 5,
    POSITION_SL = 6,
    POSITION_TP = 7,    
    POSITION_SWAP = 9,
    POSITION_PROFIT = 10
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_POSITION_PROPERTY_STRING                                   |
//  +-------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_STRING{
    POSITION_SYMBOL,
    POSITION_COMMENT = 11,
    POSITION_EXTERNAL_ID = 19
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_DEAL_TYPE                                                  |
//  +-------------------------------------------------------------------+
enum ENUM_DEAL_TYPE{
    DEAL_TYPE_BUY,
    DEAL_TYPE_SELL
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_DEAL_ENTRY                                                 |
//  +-------------------------------------------------------------------+
enum ENUM_DEAL_ENTRY{
    DEAL_ENTRY_IN,
    DEAL_ENTRY_OUT,
    DEAL_ENTRY_INOUT,
    DEAL_ENTRY_OUT_BY
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_DEAL_PROPERTY_INTEGER                                      |
//  +-------------------------------------------------------------------+
enum ENUM_DEAL_PROPERTY_INTEGER{
    DEAL_TICKET,
    DEAL_ORDER,
    DEAL_TIME,
    DEAL_TIME_MSC,
    DEAL_TYPE,
    DEAL_ENTRY,
    DEAL_MAGIC,
    DEAL_REASON,
    DEAL_POSITION_ID
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_DEAL_PROPERTY_DOUBLE                                       |
//  +-------------------------------------------------------------------+
enum ENUM_DEAL_PROPERTY_DOUBLE{
    DEAL_VOLUME,
    DEAL_PRICE,
    DEAL_COMMISSION,
    DEAL_SWAP,
    DEAL_PROFIT,
    DEAL_FEE,
    DEAL_SL,
    DEAL_TP
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_DEAL_PROPERTY_STRING                                       |
//  +-------------------------------------------------------------------+
enum ENUM_DEAL_PROPERTY_STRING{
    DEAL_SYMBOL,
    DEAL_COMMENT,
    DEAL_EXTERNAL_ID
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_TRADE_REQUEST_ACTIONS                                      |
//  +-------------------------------------------------------------------+
enum ENUM_TRADE_REQUEST_ACTIONS{
    TRADE_ACTION_DEAL,
    TRADE_ACTION_PENDING,
    TRADE_ACTION_SLTP,
    TRADE_ACTION_MODIFY,
    TRADE_ACTION_REMOVE,
    TRADE_ACTION_CLOSE_BY
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_ORDER_TYPE_FILLING                                         |
//  +-------------------------------------------------------------------+
enum ENUM_ORDER_TYPE_FILLING{
    ORDER_FILLING_FOK,
    ORDER_FILLING_IOC,
    ORDER_FILLING_BOC,
    ORDER_FILLING_RETURN
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_ORDER_TYPE_TIME                                            |
//  +-------------------------------------------------------------------+
enum ENUM_ORDER_TYPE_TIME{
    ORDER_TIME_GTC,
    ORDER_TIME_DAY,
    ORDER_TIME_SPECIFIED,
    ORDER_TIME_SPECIFIED_DAY
};
#endif