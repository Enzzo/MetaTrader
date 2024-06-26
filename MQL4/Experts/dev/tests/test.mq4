#property copyright "Sergey"
#property link "http://mql5.com/enzzo"
#property version "1.00"

#include <dev/lbr/lbr_view.mqh>
#include <dev/lbr/yet_another_view.mqh>

#include <dev/lbr/lbr_model.mqh>

#include <dev/lbr/lbr_controller.mqh>

lbr_model* m1 = new lbr_model();

lbr_controller* c1 = new lbr_controller(m1);

lbr_view* v1 = new lbr_view(m1);
yet_another_view* v2 = new yet_another_view(m1);

int OnInit(){
   
   m1.set_price(0.1234);
   
   return INIT_SUCCEEDED;
}

void OnTick(){

}

void OnChartEvent(const int id,         // идентификатор события   
                  const long& lparam,   // параметр события типа long 
                  const double& dparam, // параметр события типа double 
                  const string& sparam  // параметр события типа string
                  ){
   
}
void OnDeinit(const int reason){
   if(m1 != NULL)
      delete m1;
   if(c1 != NULL)
      delete c1;
   if(v1 != NULL)
      delete v1;
   if(v2 != NULL)
      delete v2;
}