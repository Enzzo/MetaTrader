#include <dev/observer.mqh>
#include <dev/lbr/lbr_model.mqh>

class lbr_view : public observer{
   lbr_model* _model;
   string _name;
   
public:
   
   lbr_view(lbr_model* model) : _model(model), _name("lbr_view"){
      _model.add_observer(&this);
   }
   
   void update() override {
      Print(__FUNCTION__+ " in lbr_view " + DoubleToString(_model.get_price(), 2));
   }
};