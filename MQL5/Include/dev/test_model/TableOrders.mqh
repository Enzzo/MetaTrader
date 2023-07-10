#property copyright "Sergey Vasilev"
#property link "http://www.mql5.com/Enzzo"

#include <Trade/OrderInfo.mqh>
#include <Trade/HistoryOrderInfo.mqh>
#include <Arrays/List.mqh>

class CTableOrders : public CObject{
private:
    ulong           m_magic;        // магик эксперта, выставившего ордер
    ulong           m_ticket;       // Тикет основного ордера
    ulong           m_ticket_sl;    // Тикет ордера выкупа сделки, совершённой на основании основного ордера (Stop Loss)
    ulong           m_ticket_tp;    // Тикет ордера выкупа сделки, совершённой на основании основного ордера (Take Profit)
    ENUM_ORDER_TYPE m_type;         // Тип основного ордера
    datetime        m_time_setup;   // Время установки ордера
    double          m_price;        // Цена ордера
    double          m_sl;           // Цена предполагаемого Stop Loss
    double          m_tp;           // Цена предполагаемого Take Profit
    double          m_volume_initial;//Объём ордера 

public:
                    CTableOrders();
    bool            Add(COrderInfo& order_info, double stop_loss, double take_profit);
    bool            Add(CHistoryOrderInfo& history_order_info, double stop_loss, double take_profit);
    double          StopLoss(void) const {return(m_sl);};
    double          TakeProfit(void) const {return (m_tp);};
    ulong           Magic(void) const {return (m_magic);};
    ulong           Ticket(void) const {return (m_ticket);};
    int             Type() const;
    datetime        TimeSetup() const {return (m_time_setup);};
    double          Price() const {return (m_price);};
    double          VolumeInitial() const {return (m_volume_initial);};
};

CTableOrders::CTableOrders(void){
    m_magic = 0;
    m_ticket = 0;
    m_type = 0;
    m_time_setup = 0;
    m_price = 0.0;
    m_volume_initial = 0.0;
}

bool CTableOrders::Add(COrderInfo& order_info, double stop_loss, double take_profit){
    if(OrderSelect(order_info.Ticket())){
        m_magic = order_info.Magic();
        m_ticket = order_info.Ticket();
        m_type = (ENUM_ORDER_TYPE)order_info.Type();
        m_time_setup = order_info.TimeSetup();
        m_volume_initial = order_info.VolumeInitial();
        m_price = order_info.PriceOpen();
        m_sl = stop_loss;
        m_tp = take_profit;
        return (true);
    }
    return (false);
}

bool CTableOrders::Add(CHistoryOrderInfo& history_order_info, double stop_loss, double take_profit){
    if(HistoryOrderSelect(history_order_info.Ticket())){
        m_magic = history_order_info.Magic();
        m_ticket = history_order_info.Ticket();
        m_type = (ENUM_ORDER_TYPE)history_order_info.Type();
        m_time_setup = history_order_info.TimeSetup();
        m_volume_initial = history_order_info.VolumeInitial();
        m_price = history_order_info.PriceOpen();
        m_sl = stop_loss;
        m_tp = take_profit;
        return (true);
    }
    return (false);
}

int CTableOrders::Type() const{
    return ((ENUM_ORDER_TYPE)m_type);
}