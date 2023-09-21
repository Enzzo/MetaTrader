#include <dev\SymbolInfo.mqh>

//----------------------------------------------------------+
//              class money_management                      |
//----------------------------------------------------------+
class money_management{
public:
    money_management()
      : _symbol(){
         _symbol.Name(Symbol());
      }
    ;
    money_management(const string symbol)
      : _symbol(){
      _symbol.Name(symbol);
    }
    
   ~money_management(){}; 

    const double min_lot() const;
    const double max_lot() const;
    const double auto_lot(double risk, int points, double comission = 0.0) const;

private:
   CSymbolInfo _symbol;
};

//----------------------------------------------------------+
//              class money_management                      |
//----------------------------------------------------------+
//                      min_lot                             |
//----------------------------------------------------------+
const double money_management::min_lot(void)const{
   return _symbol.LotsMin();
}

//----------------------------------------------------------+
//              class money_management                      |
//----------------------------------------------------------+
//                      max_lot                             |
//----------------------------------------------------------+
const double money_management::max_lot(void)const{
   return _symbol.LotsMax();
}

//----------------------------------------------------------+
//              class money_management                      |
//----------------------------------------------------------+
//                      auto_lot                            |
//----------------------------------------------------------+
const double money_management::auto_lot(double risk,int points,double comission = 0.0)const{
   double lot = NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)/100*risk/(comission + points*_symbol.TickValue())), 2);;
   
   if(lot > _symbol.LotsMax()){
      lot = _symbol.LotsMax();
   }
   if(lot < _symbol.LotsMin()){
      lot = _symbol.LotsMin();
   }
   return lot;
}
/*
double AutoLot(const double r, const int p){
   double l = MarketInfo(Symbol(), MODE_MINLOT);
   
   l = NormalizeDouble((AccountBalance()/100*r/(COMISSION + p*MarketInfo(Symbol(), MODE_TICKVALUE))), 2);
   
   if(l > MarketInfo(Symbol(), MODE_MAXLOT))l = MarketInfo(Symbol(), MODE_MAXLOT);
   if(l < MarketInfo(Symbol(), MODE_MINLOT))l = MarketInfo(Symbol(), MODE_MINLOT);
   return l;
}*/