// #ifdef MT4
// //  +-------------------------------------------------------------------+
// //  |   Position Functions                                              |
// //  +-------------------------------------------------------------------+
// //  |   long PositionGetInteger                                         |
// //  +-------------------------------------------------------------------+
// long PositionGetInteger(ENUM_POSITION_PROPERTY_INTEGER property_id){
//     long result = EMPTY_VALUE;

//     switch(property_id){
//         case POSITION_TICKET:{
//             result = OrderTicket();
//             break;
//         }
//         case POSITION_TIME:{
//             result = OrderOpenTime();
//             break;
//         }
//         case POSITION_TIME_MSC:{break;}
//         case POSITION_TIME_UPDATE:{break;}
//         case POSITION_TYPE:{
//             result = OrderType();
//             break;
//         }
//         case POSITION_MAGIC:{
//             result = OrderMagicNumber();
//             break;
//         }
//         case POSITION_IDENTIFIER:{
//             result = OrderTicket();
//             break;
//         }
//         case POSITION_REASON:{break;}
//     }
//     return result;
// }

// //  +-------------------------------------------------------------------+
// //  |   Position Functions                                              |
// //  +-------------------------------------------------------------------+
// //  |   bool PositionGetInteger                                         |
// //  +-------------------------------------------------------------------+
// bool PositionGetInteger(ENUM_POSITION_PROPERTY_INTEGER property_id, long& long_var){
//     long_var = PositionGetInteger(property_id);
//     return (long_var == EMPTY_VALUE)?false:true;
// }

// //  +-------------------------------------------------------------------+
// //  |   Position Functions                                              |
// //  +-------------------------------------------------------------------+
// //  |   double PositionGetDouble                                          |
// //  +-------------------------------------------------------------------+
// double PositionGetDouble(ENUM_POSITION_PROPERTY_DOUBLE property_id){
//     double result = EMPTY_VALUE;
//     switch(property_id){
//         case POSITION_VOLUME:{
//             result = OrderLots();
//             break;
//         }
//         case POSITION_PRICE_OPEN:{
//             result = OrderOpenPrice();
//             break;
//         }
//         case POSITION_SL:{
//             result = OrderStopLoss();
//             break;
//         }
//         case POSITION_TP:{
//             result = OrderTakeProfit();
//             break;
//         }
//         case POSITION_PRICE_CURRENT:{
//             if(OrderType() == ORDER_TYPE_BUY){
//                 result = SymbolInfoDouble(OrderSymbol(), SYMBOL_ASK);
//             }
//             else if(OrderType() == ORDER_TYPE_SELL){
//                 result = SymbolInfoDouble(OrderSymbol(), SYMBOL_BID);
//             }
//             break;
//         }
//         case POSITION_SWAP:{
//             result = OrderSwap();
//             break;
//         }
//         case POSITION_PROFIT:{
//             result = OrderProfit();
//             break;
//         }
//     }

//     return result;
// }

// //  +-------------------------------------------------------------------+
// //  |   Position Functions                                              |
// //  +-------------------------------------------------------------------+
// //  |   bool PositionGetDouble                                          |
// //  +-------------------------------------------------------------------+
// bool PositionGetDouble(ENUM_POSITION_PROPERTY_DOUBLE property_id, double& double_var){
//     double_var = PositionGetDouble(property_id);
//     return (double_var == EMPTY_VALUE)?false:true;
// }

// //  +-------------------------------------------------------------------+
// //  |   Position Functions                                              |
// //  +-------------------------------------------------------------------+
// //  |   string PositionGetString                                          |
// //  +-------------------------------------------------------------------+
// // string PositionGetString(ENUM_POSITION_PROPERTY_STRING property_id){
// //     string result = "";
// //     switch(property_id){
// //         case POSITION_SYMBOL:{
// //             result = OrderSymbol();
// //             break;
// //         }
// //         case POSITION_COMMENT:{
// //             result = OrderComment();
// //             break;
// //         }
// //     }

// //     return result;
// // }

// //  +-------------------------------------------------------------------+
// //  |   Position Functions                                              |
// //  +-------------------------------------------------------------------+
// //  |   bool PositionGetString                                          |
// //  +-------------------------------------------------------------------+
// // bool PositionGetString(ENUM_POSITION_PROPERTY_DOUBLE property_id, string& string_var){
// //     string_var = PositionGetString(property_id);
// //     return (string_var == "")?false:true;
// // }

// #endif