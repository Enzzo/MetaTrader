#include <Object.mqh>
#include <Trade/AccountInfo.mqh>
#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/DealInfo.mqh>

#include <TableOrders.mqh>
#include <Time.mqh>

struct n_orders{
    int all_orders;
    int long_orders;
    int short_orders;
    int buy_sell_orders;
    int delayed_orders;
    int buy_orders;
    int sell_orders;
    int buy_stop_orders;
    int sell_stop_orders;
    int buy_limit_orders;
    int sell_limit_orders;
    int buy_stop_limit_orders;
    int sell_stop_limit_orders;
};

enum ENUM_ORDER_MODE{
    ORDER_ADD, ORDER_DELETE
};

enum ENUM_TYPE_DELETED_ORDER{

};

class mm{
public:
    mm(){};
};

class CModel : public CObject{
protected:
    long                m_magic;
    string              m_symbol;
    ENUM_TIMEFRAMES     m_timeframe;
    string              m_model_name;
    double              m_delta;
    CTableOrders*       table;
    CList*              ListTableOrders;
    CAccountInfo        m_account_info;
    CTrade              m_trade;
    CSymbolInfo         m_symbol_info;
    COrderInfo          m_order_info;
    CHistoryOrderInfo   m_history_order_info;
    CPositionInfo       m_position_info;
    CDealInfo           m_deal_info;
    t_period            m_timing;

public:
                        CModel(){Init();}
                       ~CModel(){Deinit();}
    string              Name(){return (m_model_name);}
    void                Name(string name){m_model_name = name;}
    ENUM_TIMEFRAMES     Timeframe(void){return (m_timeframe);}
    string              Symbol(void){return (m_symbol);}
    void                Symbol(string set_symbol){m_symbol = set_symbol;}
    virtual bool        Init();
    virtual void        Deinit(){delete ListTableOrders;}
    virtual bool        Processing(){return(true);}
    double              GetMyPosition();
    bool                Delete(ENUM_TYPE_DELETED_ORDER);
    bool                Delete(ulong Ticket);
    void                CloseAllPosition();
    // virtual bool        Trade();

protected:
    bool                Add(COrderInfo& order_info, double stop_loss, double take_profit);
    bool                Add(CHistoryOrderInfo& history_order_info, double stop_loss, double take_profit);

    void                GetNumberOrders(n_orders& orders);
    bool                SendOrder(  string symbol, ENUM_ORDER_TYPE op_type, ENUM_ORDER_MODE op_mode, ulong ticket, double lot, 
                                    double price, double stop_loss, double take_profit, string comment);
};

bool CModel::SendOrder( string symbol,
                        ENUM_ORDER_TYPE op_type,
                        ENUM_ORDER_MODE op_mode,
                        ulong ticket,
                        double lot,
                        double price,
                        double stop_loss,
                        double take_profit,
                        string comment){
    ulong code_return = 0;
    CSymbolInfo symbol_info;
    CTrade      trade;
    
    symbol_info.Name(symbol);
    symbol_info.RefreshRates();
    mm send_order_mm;

    double lot_current;
    double lot_send = lot;
    double lot_max = m_symbol_info.LotsMax();

    bool res = false;
    int floor_lot = (int)MathFloor(lot/lot_max);
    if(MathMod(lot, lot_max) == 0) floor_lot -= 1;
    int itteration = (int)MathCeil(lot/lot_max);
    
    return (res);
}