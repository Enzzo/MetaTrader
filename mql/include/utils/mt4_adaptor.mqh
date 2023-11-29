#ifdef MT4

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
    POSITION_VOLUME,
    POSITION_PRICE_OPEN,
    POSITION_SL,
    POSITION_TP,
    POSITION_PRICE_CURRENT,
    POSITION_SWAP,
    POSITION_PROFIT
};

//  +-------------------------------------------------------------------+
//  |   ENUMERATORS                                                     |
//  +-------------------------------------------------------------------+
//  |   ENUM_POSITION_PROPERTY_STRING                                   |
//  +-------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_STRING{
    POSITION_SYMBOL,
    POSITION_COMMENT,
    POSITION_EXTERNAL_ID
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

//  +-------------------------------------------------------------------+
//  |   Position Functions                                              |
//  +-------------------------------------------------------------------+
//  |   long PositionGetInteger                                         |
//  +-------------------------------------------------------------------+
long PositionGetInteger(ENUM_POSITION_PROPERTY_INTEGER property_id){
    long result = EMPTY_VALUE;

    switch(property_id){
        case POSITION_TICKET:{
            result = OrderTicket();
            break;
        }
        case POSITION_TIME:{
            result = OrderOpenTime();
            break;
        }
        case POSITION_TIME_MSC:{break;}
        case POSITION_TIME_UPDATE:{break;}
        case POSITION_TYPE:{
            result = OrderType();
            break;
        }
        case POSITION_MAGIC:{
            result = OrderMagic();
            break;
        }
        case POSITION_IDENTIFIER:{
            result = OrderTicket();
            break;
        }
        case POSITION_REASON:{break;}
    }
    return result;
}

//  +-------------------------------------------------------------------+
//  |   Position Functions                                              |
//  +-------------------------------------------------------------------+
//  |   bool PositionGetInteger                                         |
//  +-------------------------------------------------------------------+
bool PositionGetInteger(ENUM_POSITION_PROPERTY_INTEGER property_id, long& long_var){
    long_var = PositionGetInteger(property_id);
    return (long_var == EMPTY_VALUE)?false:true;
}

//  +-------------------------------------------------------------------+
//  |   Position Functions                                              |
//  +-------------------------------------------------------------------+
//  |   double PositionGetDouble                                          |
//  +-------------------------------------------------------------------+
double PositionGetDouble(ENUM_POSITION_PROPERTY_DOUBLE property_id){
    double result = EMPTY_VALUE;
    switch(property_id){
        case POSITION_VOLUME:{
            result = OrderLots();
            break;
        }
        case POSITION_PRICE_OPEN:{
            result = OrderOpenPrice();
            break;
        }
        case POSITION_SL:{
            result = OrderStopLoss();
            break;
        }
        case POSITION_TP:{
            result = OrderTakeProfit();
            break;
        }
        case POSITION_PRICE_CURRENT:{
            if(OrderType() == ORDER_TYPE_BUY){
                result = SymbolInfoDouble(OrderSymbol(), SYMBOL_ASK);
            }
            else if(OrderType() == ORDER_TYPE_SELL){
                result = SymbolInfoDouble(OrderSymbol(), SYMBOL_BID);
            }
            break;
        }
        case POSITION_SWAP:{
            result = OrderSwap();
            break;
        }
        case POSITION_PROFIT:{
            result = OrderProfit();
            break;
        }
    }

    return result;
}

//  +-------------------------------------------------------------------+
//  |   Position Functions                                              |
//  +-------------------------------------------------------------------+
//  |   bool PositionGetDouble                                          |
//  +-------------------------------------------------------------------+
bool PositionGetDouble(ENUM_POSITION_PROPERTY_DOUBLE property_id, double& double_var){
    double_var = PositionGetDouble(property_id);
    return (double_var == EMPTY_VALUE)?false:true;
}

//  +-------------------------------------------------------------------+
//  |   Position Functions                                              |
//  +-------------------------------------------------------------------+
//  |   string PositionGetString                                          |
//  +-------------------------------------------------------------------+
string PositionGetString(ENUM_POSITION_PROPERTY_STRING property_id){
    string result = EMPTY_VALUE;
    switch(property_id){
        case POSITION_SYMBOL:{
            result = OrderSymbol();
            break;
        }
        case POSITION_COMMENT:{
            result = OrderComment();
            break;
        }
    }

    return result;
}

//  +-------------------------------------------------------------------+
//  |   Position Functions                                              |
//  +-------------------------------------------------------------------+
//  |   bool PositionGetString                                          |
//  +-------------------------------------------------------------------+
bool PositionGetString(ENUM_POSITION_PROPERTY_DOUBLE property_id, string& string_var){
    string_var = PositionGetString(property_id);
    return (string_var == EMPTY_VALUE)?false:true;
}

//  +-------------------------------------------------------------------+
//  |   STRUCTURES                                                      |
//  +-------------------------------------------------------------------+
//  |   MqlTradeRequest                                                 |
//  +-------------------------------------------------------------------+
struct MqlTradeRequest { 
    ENUM_TRADE_REQUEST_ACTIONS    action;           // Тип выполняемого действия 
    ulong                         magic;            // Штамп эксперта (идентификатор magic number) 
    ulong                         order;            // Тикет ордера 
    string                        symbol;           // Имя торгового инструмента 
    double                        volume;           // Запрашиваемый объем сделки в лотах 
    double                        price;            // Цена  
    double                        stoplimit;        // Уровень StopLimit ордера 
    double                        sl;               // Уровень Stop Loss ордера 
    double                        tp;               // Уровень Take Profit ордера 
    ulong                         deviation;        // Максимально приемлемое отклонение от запрашиваемой цены 
    ENUM_ORDER_TYPE               type;             // Тип ордера 
    ENUM_ORDER_TYPE_FILLING       type_filling;     // Тип ордера по исполнению 
    ENUM_ORDER_TYPE_TIME          type_time;        // Тип ордера по времени действия 
    datetime                      expiration;       // Срок истечения ордера (для ордеров типа ORDER_TIME_SPECIFIED) 
    string                        comment;          // Комментарий к ордеру 
    ulong                         position;         // Тикет позиции 
    ulong                         position_by;      // Тикет встречной позиции 
};

#endif