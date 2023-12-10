//+------------------------------------------------------------------+
//|                                                           mm.mqh |
//|                            Copyright 2010, Vasily Sokolov (C-4). |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, Vasily Sokolov (C-4)."
#property link      "http://www.mql5.com"

#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

// +--------------------------------------------------------+
// |                        class mm                        |
// +--------------------------------------------------------+
class mm{
public:
   double            optimal_f(string symbol, ENUM_ORDER_TYPE op_type, double open_price, double stop_loss, double f);
   double            jons_fp(string symbol, ENUM_ORDER_TYPE op_type, double open_price, double min_lot, double begin_balance,  double delta);
   double            CheckLot(string symbol, double lot, ENUM_ORDER_TYPE op_type);
   double            CheckMargin(string symbol, ENUM_ORDER_TYPE op_type, double lot, double open_price);

private:
   double            _current_price;
   double            _sl;
   CSymbolInfo       _symbol_info;
   CAccountInfo      _account_info;
   CPositionInfo     _position_info;

};

double mm::optimal_f(string symbol, ENUM_ORDER_TYPE op_type, double open_price, double stop_loss, double f){
   double point;
   double tick_value;
   double min_risk;
   double min_risk_percent;
   double lot_step;
   double lot;
   //double price;
   //double margin;
   
   //ENUM_POINTER_TYPE position_type;
   //int position_type;
   //double position_volume;
   //double position_limit;
   //double lot_limit;
   //double lot_margin;
   
   _symbol_info.Name(symbol);
   _symbol_info.RefreshRates();
   if(op_type==ORDER_TYPE_BUY_LIMIT||op_type==ORDER_TYPE_BUY_STOP||
      op_type==ORDER_TYPE_BUY_STOP_LIMIT||op_type==ORDER_TYPE_BUY){
      _current_price=_symbol_info.Ask();  
   }
   if(op_type==ORDER_TYPE_SELL_LIMIT||op_type==ORDER_TYPE_SELL_STOP||
      op_type==ORDER_TYPE_SELL_STOP_LIMIT||op_type==ORDER_TYPE_SELL){
      _current_price=_symbol_info.Bid();
   }
   
   if((stop_loss<=0.0)||(f>1.0)||(f<=0.0)){
      lot=0.1;
   }
   else{
      tick_value=_symbol_info.TickValue();
      point=MathAbs(open_price - stop_loss)/_symbol_info.Point();
      min_risk=point*tick_value*_symbol_info.LotsStep();
      min_risk_percent=min_risk/_account_info.Balance();
      lot_step=MathFloor(f/min_risk_percent);
      lot=lot_step*_symbol_info.LotsStep();
      if(lot<_symbol_info.LotsMin())lot=_symbol_info.LotsMin();

   }
   lot=CheckLot(symbol, lot, op_type);
   lot=CheckMargin(symbol, op_type, lot, open_price);
   return(lot);
}

double mm::jons_fp(string symbol,ENUM_ORDER_TYPE op_type,double open_price, double min_lot, double begin_balance, double delta)
{
   double current_profit;
   double d, x;
   double lot;
   _symbol_info.Name(symbol);
   _symbol_info.RefreshRates();
   //_balance=11375.03;
   if(delta>0){
      current_profit=_account_info.Balance()-begin_balance;
      if(current_profit<=0)lot=min_lot;
      else{
         d=(current_profit/(delta));
         d=d*2.0;
         x=(1.0+MathSqrt(1+4.0*d))/2; //������� �� ��������!!!
         x=MathFloor(x);
         if(x==0.0)lot=min_lot;
         else{
            lot=min_lot+((x-1)*_symbol_info.LotsStep());//!!! Not Change !!!
         }
      }
   }
   else lot=0.1;
   lot=CheckLot(symbol, lot, op_type);
   lot=CheckMargin(symbol, op_type, lot, open_price);
   return(lot);
}

// +----------------------------------------------------------+
// |                        class mm                          |
// +----------------------------------------------------------+
// |                     double CheckLot                      |
// +----------------------------------------------------------+
double mm::CheckLot(string symbol, double lot, ENUM_ORDER_TYPE op_type)
{
   ENUM_POSITION_TYPE position_type;
   double             position_volume;
   double             position_limit;
   double             lot_limit;
   if(lot==EMPTY_VALUE)return(EMPTY_VALUE);

   _position_info.Select(symbol);
   position_type=(ENUM_POSITION_TYPE)_position_info.Type();
   if(_position_info.Select(symbol))
      position_volume=_position_info.Volume();
   else position_volume=0.0;
   position_limit=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_LIMIT);
   if(position_limit!=0.0){
      if(position_type==POSITION_TYPE_BUY){
         if(op_type==ORDER_TYPE_BUY)
            lot_limit=position_limit-position_volume;
         if(op_type==ORDER_TYPE_SELL)
            lot_limit=position_limit;
      }
      if(position_type==POSITION_TYPE_SELL){
         if(op_type==ORDER_TYPE_SELL)
            lot_limit=position_limit-position_volume;
         if(op_type==ORDER_TYPE_BUY)
            lot_limit=position_limit;
      }
      //Print("LOT LIMIT: ", lot_limit, " POSITION VOLUME: ", position_volume);
      if(lot_limit<=0.0){
         return(EMPTY_VALUE);
      }
      //Print("Current lot: ", NormalizeDouble(lot,1), " Limit lot: ", lot_limit, " position volume: ", position_volume);
      if(lot>lot_limit)lot=lot_limit;
   }
   return(lot);
}

//----------------------------------------------------------+
//                         class mm                         |
//----------------------------------------------------------+
//                    double CheckMargin                    |
//----------------------------------------------------------+
double mm::CheckMargin(string symbol, ENUM_ORDER_TYPE op_type, double lot, double open_price){
   string my_currency = _account_info.Currency();
   double demanded_margin=_account_info.MarginCheck(symbol, op_type, lot, open_price); 
   double free_margin=_account_info.FreeMargin();
   double delta, current_lot;
   if(lot==EMPTY_VALUE)return(EMPTY_VALUE);
   if(demanded_margin==EMPTY_VALUE){
      Print("To calculate a demanded margin it was not possible. I return initiating volume.");
      return(lot);
   }
   if(free_margin<=0){
      //Print("There is no the free margin ( ", NormalizeDouble(free_margin, 1), "). I pass a signal.");
      return(EMPTY_VALUE);
   }
   if(free_margin<=demanded_margin){
         Print("It is not enough free margin (", NormalizeDouble(free_margin, 1), 
         "). Demanded margin is ", NormalizeDouble(demanded_margin, 1), ". I try to lower volume ", lot, ".");
      delta=demanded_margin/free_margin;
      current_lot=lot/delta;
      if(current_lot<_symbol_info.LotsMin()){
         Print("It is not enough free margin for open minimum lot. Skip signal");
         if(_account_info.Margin()==0.0)
            Print("Margin not using. Technicals margin-call");
         return(EMPTY_VALUE);
      }
      lot=NormalizeDouble(current_lot-_symbol_info.LotsMin(), 1);
   }
   return(lot);
}


