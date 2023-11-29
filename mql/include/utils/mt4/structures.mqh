#ifdef MT4
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