//+------------------------------------------------------------------+
//|                                                eaGridGeneric.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <UIGrid.mqh>

UI       *ui;  //Графический интерфейс
UIdata   data; //Данные

input int      mgc   = 9999967; //Магик
input double   vol   = 0.01;    //Объем
input int      bStp  = 100;     //Шаг сетки (если ручн)
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   data.lot  = vol;
   data.mgc  = mgc;
   data.offs = bStp;
   
   if(Total()== 0){
      ui = new MainWindow(data);      
   }
   else{ //если остались ордера по магику, то пробуем получить настройки из файла. Если нет, то обычная инициализация
      if(!ui.GetInputsFromFile(Symbol()))
      ui = new GridWindow(data);
   }
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   Comment("");
   //Если какие-то ордера остались, то сохраняем настройки советника в файл
   if(ui != NULL)delete ui;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   Comment(data.offs);
   ENUM_BEHAVIOURS b = ui.GetBehaviour();
   switch(b){
      
      case(B_WINDOW_LIST):
         if(ui != NULL)delete ui;
         
         ui = new SlctWindow(data);  
         break;
      
      case(B_WINDOW_GRID):
         if(ui != NULL)delete ui;
         
         ui = new GridWindow(data);
         break;
      
      case(B_MODE_SELECTED):
         if(ui != NULL)delete ui;
         
         if(Total() == 0)
            ui = new MainWindow(data);
         else
            ui = new GridWindow(data);
         break;       
   }

}
//+------------------------------------------------------------------+

ushort Total(){
   ushort count = 0;
   if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == mgc && OrderSymbol() == Symbol())
            count++;
      }
   }
   return count;
}