#include <dev/lbr/lbr_model.mqh>

class lbr_controller{
   lbr_model* _model;

public:
   lbr_controller(lbr_model* model) : _model(model){
   }
   
};