#include <trade/symbol_info.mqh>

// +--------------------------------------------------------+
// |                        class mm                        |
// +--------------------------------------------------------+
//
class mm{
public:
    mm()
      : _symbol(){
         _symbol.Name(Symbol());
      }
    ;
    mm(const string symbol)
      : _symbol(){
      _symbol.Name(symbol);
    }
    
   ~mm(){}; 

    const double min_lot() const;
    const double max_lot() const;
    const double auto_lot(double risk, int points, double comission = 0.0) const;

private:
   short get_lot_digits() const;
   
private:
   CSymbolInfo _symbol;
};

//----------------------------------------------------------+
//                         class mm                         |
//----------------------------------------------------------+
//                         min_lot                          |
//----------------------------------------------------------+
const double mm::min_lot(void)const{
   return _symbol.LotsMin();
}

//----------------------------------------------------------+
//                         class mm                         |
//----------------------------------------------------------+
//                         max_lot                          |
//----------------------------------------------------------+
const double mm::max_lot(void)const{
   return _symbol.LotsMax();
}

//----------------------------------------------------------+
//                         class mm                         |
//----------------------------------------------------------+
//                         auto_lot                         |
//----------------------------------------------------------+
const double mm::auto_lot(double risk,int points,double comission = 0.0)const{
   double lot = NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)*.01*risk/(comission + points*_symbol.TickValue())), get_lot_digits());;
   
   if(lot > _symbol.LotsMax()){
      lot = _symbol.LotsMax();
   }
   if(lot < _symbol.LotsMin()){
      lot = _symbol.LotsMin();
   }
   return lot;
}

//----------------------------------------------------------+
//                         class mm                         |
//----------------------------------------------------------+
//                  short get_lot_digits                    |
//----------------------------------------------------------+
short mm::get_lot_digits() const{
   double step = SymbolInfoDouble(_symbol.Name(), SYMBOL_VOLUME_STEP);
   short d = 0;

   while(step < 1.0){
      ++d;
      step *= 10;
   }
   
   return d;
}