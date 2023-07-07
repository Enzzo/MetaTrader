#include <Object.mqh>
#include <Trade/AccountInfo.mqh>
#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/DealInfo.mqh>

#include <TableOrders.mqh>
#include <Time.mqh>

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