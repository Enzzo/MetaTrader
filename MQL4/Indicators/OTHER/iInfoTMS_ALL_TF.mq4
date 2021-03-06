//+------------------------------------------------------------------+
//|                                                        iInfo.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window

int mtp = 1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   ChartRedraw();
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Info")!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
   if(Digits() == 5 || Digits() == 3)mtp = 1;
   DrawTable();
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
//---
   if(prev_calculated >= 10)UpdateTable();
   if(OrdersHistoryTotal()>0){
      static int total = 0;
      if(total != OrdersHistoryTotal()){
         DrawDeals();      
         total = OrdersHistoryTotal();
      }
   }
   /*Print("///////////");
   Print("0 ",iCustom(Symbol(), PERIOD_CURRENT, "CCI - nrp", 4, 0));
   Print("1 ",iCustom(Symbol(), PERIOD_CURRENT, "CCI - nrp", 4, 1));
   Print("2 ",iCustom(Symbol(), PERIOD_CURRENT, "CCI - nrp", 4, 2));
   Print("3 ",iCustom(Symbol(), PERIOD_CURRENT, "CCI - nrp", 4, 3));
   Print("4 ",iCustom(Symbol(), PERIOD_CURRENT, "CCI - nrp", 4, 4));
   Print("5 ",iCustom(Symbol(), PERIOD_CURRENT, "CCI - nrp", 4, 5));*/
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

void OnDeinit(const int reason){
//---
   ChartRedraw();
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Info")!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
}

void DrawDeals(){
   for(int i = OrdersHistoryTotal()-1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)){
         if(!FindObject(OrderTicket())){
            static int n = 0;
            TrendCreate(ChartID(), "InfoHDOrder_"+(string)OrderTicket()+"_"+(string)n,  0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), OrderType() == 0?clrBlue:clrRed, 1, 2);//t == 0?clrBlue:clrRed);
            if(OrderTakeProfit() != 0){
               TrendCreate(ChartID(), "InfoHDProfit_"+(string)OrderTicket()+"_"+(string)n,0, OrderOpenTime(), OrderTakeProfit(), OrderCloseTime(), OrderTakeProfit(), clrRed, 1, 2);
               TrendCreate(ChartID(), "InfoHDSUPP_"+(string)OrderTicket()+"_"+(string)n,0, OrderOpenTime(), OrderOpenPrice(), OrderOpenTime(), OrderTakeProfit(), clrRed, 1, 1);
            }
            if(OrderStopLoss() != 0){
               TrendCreate(ChartID(), "InfoHDLoss_"+(string)OrderTicket()+"_"+(string)n,   0, OrderOpenTime(), OrderStopLoss(), OrderCloseTime(), OrderStopLoss(), clrRed, 1, 2);
               TrendCreate(ChartID(), "InfoHDSUPL_"+(string)OrderTicket()+"_"+(string)n,0, OrderOpenTime(), OrderOpenPrice(), OrderOpenTime(), OrderStopLoss(), clrRed, 1, 1);
            }
            MarkCreate(ChartID(),  "InfoHDStart_"+(string)OrderTicket()+"_"+(string)n, 0, OrderType() == 0?OBJ_ARROW_BUY:OBJ_ARROW_SELL, OrderOpenTime(), OrderOpenPrice(),OrderType() == 0?clrBlue:clrRed, 0, 3);
            MarkCreate(ChartID(),  "InfoHDStop_"+(string)OrderTicket()+"_"+(string)n,  0, OrderProfit() < 0.0?OBJ_ARROW_STOP:OBJ_ARROW_CHECK, OrderCloseTime(), OrderClosePrice(), OrderProfit() > 0.0?clrGreen:clrRed, 0, 3);
            n++;
         }
      }
   }         
}

bool FindObject(int tkt){
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>= 0; i--){
         if(StringFind(ObjectName(ChartID(), i), (string)tkt)!=-1)return true;
      }
   }
   return false;
}

void UpdateTable(){
   
   if(ObjectsTotal()>0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i),"InfoTXT2-")!= -1 || StringFind(ObjectName(ChartID(), i),"InfoRCT")!= -1)
            ObjectDelete(ObjectName(ChartID(), i));
      }
   }
   
   ushort orders  = 0;
   double lots    = 0.0;
   double loss    = 0.0;
   double profit  = 0.0;
   string risk    = NULL;
   
   Checking(orders, lots, loss, profit);
   if(loss != 0.0 && AccountBalance() != 0.0)risk = (string)(int)(MathAbs(loss)/(AccountBalance()/100));
   if(loss == 0.0) risk = "0";
   
   LabelCreate(    ChartID(), "InfoTXT2-3", 0, 193, 100,CORNER_LEFT_LOWER, IntegerToString(orders),      "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT2-4", 0, 193, 81, CORNER_LEFT_LOWER, DoubleToString(lots,2),       "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT2-5", 0, 193, 62, CORNER_LEFT_LOWER, DoubleToString(loss,2)+" $",  "Arial", 10, clrRed);
   LabelCreate(    ChartID(), "InfoTXT2-6", 0, 193, 43, CORNER_LEFT_LOWER, DoubleToString(profit,2)+" $","Arial", 10, clrGreen);
   LabelCreate(    ChartID(), "InfoTXT2-7", 0, 193, 24, CORNER_LEFT_LOWER, risk == NULL?"UNC":risk+" %", "Arial", 10, clrRed);
   
   DrawSignals();
}

void DrawSignals(){
   
   double M1MA5[9];
   double M1MA23[9];
   double M1Green[9];
   double M1Red[9];
   
   double M15MA5[9];
   double M15MA23[9];
   double M15Green[9];
   double M15Red[9];
   
   double M30MA5[9];
   double M30MA23[9];
   double M30Green[9];
   double M30Red[9];
   
   double H1MA5[9];
   double H1MA23[9];
   double H1Green[9];
   double H1Red[9];
   
   double H4MA5[9];
   double H4MA23[9];
   double H4Green[9];
   double H4Red[9];
   
   double D1MA5[9];
   double D1MA23[9];
   double D1Green[9];
   double D1Red[9];
   
   double W1MA5[9];
   double W1MA23[9];
   double W1Green[9];
   double W1Red[9];
   
   for(int i = 8; i>=0; i--){
      M1MA5[i]  = iMA(    Symbol(), PERIOD_M1, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      M1MA23[i] = iMA(    Symbol(), PERIOD_M1, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      M1Green[i]= iCustom(Symbol(), PERIOD_M1, "TDI Red Green", 4, i);
      M1Red[i]  = iCustom(Symbol(), PERIOD_M1, "TDI Red Green", 5, i);
      
      M15MA5[i]  = iMA(    Symbol(), PERIOD_M15, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      M15MA23[i] = iMA(    Symbol(), PERIOD_M15, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      M15Green[i]= iCustom(Symbol(), PERIOD_M15, "TDI Red Green", 4, i);
      M15Red[i]  = iCustom(Symbol(), PERIOD_M15, "TDI Red Green", 5, i);
      
      M30MA5[i]  = iMA(    Symbol(), PERIOD_M30, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      M30MA23[i] = iMA(    Symbol(), PERIOD_M30, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      M30Green[i]= iCustom(Symbol(), PERIOD_M30, "TDI Red Green", 4, i);
      M30Red[i]  = iCustom(Symbol(), PERIOD_M30, "TDI Red Green", 5, i);
      
      H1MA5[i]  = iMA(    Symbol(), PERIOD_H1, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      H1MA23[i] = iMA(    Symbol(), PERIOD_H1, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      H1Green[i]= iCustom(Symbol(), PERIOD_H1, "TDI Red Green", 4, i);
      H1Red[i]  = iCustom(Symbol(), PERIOD_H1, "TDI Red Green", 5, i);
      
      H4MA5[i]  = iMA(    Symbol(), PERIOD_H4, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      H4MA23[i] = iMA(    Symbol(), PERIOD_H4, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      H4Green[i]= iCustom(Symbol(), PERIOD_H4, "TDI Red Green", 4, i);
      H4Red[i]  = iCustom(Symbol(), PERIOD_H4, "TDI Red Green", 5, i);
      
      D1MA5[i]  = iMA(    Symbol(), PERIOD_D1, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      D1MA23[i] = iMA(    Symbol(), PERIOD_D1, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      D1Green[i]= iCustom(Symbol(), PERIOD_D1, "TDI Red Green", 4, i);
      D1Red[i]  = iCustom(Symbol(), PERIOD_D1, "TDI Red Green", 5, i);
      
      W1MA5[i]  = iMA(    Symbol(), PERIOD_W1, 5,  2, MODE_SMA, PRICE_TYPICAL, i-2);
      W1MA23[i] = iMA(    Symbol(), PERIOD_W1, 23, 2, MODE_SMA, PRICE_TYPICAL, i-2);
      W1Green[i]= iCustom(Symbol(), PERIOD_W1, "TDI Red Green", 4, i);
      W1Red[i]  = iCustom(Symbol(), PERIOD_W1, "TDI Red Green", 5, i);
      
      if(i<8){
         if(M1MA5[i]>M1MA23[i] && M1Green[i]>M1Red[i] && (M1MA5[i+1]<=M1MA23[i+1] || M1Green[i+1]<=M1Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-0", 0, nAutoNum(i), 301, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M1MA5[i]>M1MA23[i] && M1MA5[i+1]>M1MA23[i+1] && M1Green[i]>M1Red[i] && M1Green[i+1]>M1Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-0", 0, nAutoNum(i), 301, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M1MA5[i]<M1MA23[i] && M1Green[i]<M1Red[i] && (M1MA5[i+1]>=M1MA23[i+1] || M1Green[i+1]>=M1Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-0", 0, nAutoNum(i), 301, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M1MA5[i]<M1MA23[i] && M1MA5[i+1]<M1MA23[i+1] && M1Green[i]<M1Red[i] && M1Green[i+1]<M1Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-0", 0, nAutoNum(i), 301, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-0", 0, nAutoNum(i), 301, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
            
         if(M15MA5[i]>M15MA23[i] && M15Green[i]>M15Red[i] && (M15MA5[i+1]<=M15MA23[i+1] || M15Green[i+1]<=M15Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-1", 0, nAutoNum(i), 272, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M15MA5[i]>M15MA23[i] && M15MA5[i+1]>M15MA23[i+1] && M15Green[i]>M15Red[i] && M15Green[i+1]>M15Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-1", 0, nAutoNum(i), 272, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M15MA5[i]<M15MA23[i] && M15Green[i]<M15Red[i] && (M15MA5[i+1]>=M15MA23[i+1] || M15Green[i+1]>=M15Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-1", 0, nAutoNum(i), 272, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M15MA5[i]<M15MA23[i] && M15MA5[i+1]<M15MA23[i+1] && M15Green[i]<M15Red[i] && M15Green[i+1]<M15Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-1", 0, nAutoNum(i), 272, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-1", 0, nAutoNum(i), 272, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
            
         if(M30MA5[i]>M30MA23[i] && M30Green[i]>M30Red[i] && (M30MA5[i+1]<=M30MA23[i+1] || M30Green[i+1]<=M30Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-2", 0, nAutoNum(i), 243, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M30MA5[i]>M30MA23[i] && M30MA5[i+1]>M30MA23[i+1] && M30Green[i]>M30Red[i] && M30Green[i+1]>M30Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-2", 0, nAutoNum(i), 243, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M30MA5[i]<M30MA23[i] && M30Green[i]<M30Red[i] && (M30MA5[i+1]>=M30MA23[i+1] || M30Green[i+1]>=M30Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-2", 0, nAutoNum(i), 243, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(M30MA5[i]<M30MA23[i] && M30MA5[i+1]<M30MA23[i+1] && M30Green[i]<M30Red[i] && M30Green[i+1]<M30Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-2", 0, nAutoNum(i), 243, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-2", 0, nAutoNum(i), 243, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         
         if(H1MA5[i]>H1MA23[i] && H1Green[i]>H1Red[i] && (H1MA5[i+1]<=H1MA23[i+1] || H1Green[i+1]<=H1Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-3", 0, nAutoNum(i), 214, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(H1MA5[i]>H1MA23[i] && H1MA5[i+1]>H1MA23[i+1] && H1Green[i]>H1Red[i] && H1Green[i+1]>H1Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-3", 0, nAutoNum(i), 214, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(H1MA5[i]<H1MA23[i] && H1Green[i]<H1Red[i] && (H1MA5[i+1]>=H1MA23[i+1] || H1Green[i+1]>=H1Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-3", 0, nAutoNum(i), 214, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(H1MA5[i]<H1MA23[i] && H1MA5[i+1]<H1MA23[i+1] && H1Green[i]<H1Red[i] && H1Green[i+1]<H1Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-3", 0, nAutoNum(i), 214, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-3", 0, nAutoNum(i), 214, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
      
         if(H4MA5[i]>H4MA23[i] && H4Green[i]>H4Red[i] && (H4MA5[i+1]<=H4MA23[i+1] || H4Green[i+1]<=H4Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-4", 0, nAutoNum(i), 185, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(H4MA5[i]>H4MA23[i] && H4MA5[i+1]>H4MA23[i+1] && H4Green[i]>H4Red[i] && H4Green[i+1]>H4Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-4", 0, nAutoNum(i), 185, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(H4MA5[i]<H4MA23[i] && H4Green[i]<H4Red[i] && (H4MA5[i+1]>=H4MA23[i+1] || H4Green[i+1]>=H4Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-4", 0, nAutoNum(i), 185, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(H4MA5[i]<H4MA23[i] && H4MA5[i+1]<H4MA23[i+1] && H4Green[i]<H4Red[i] && H4Green[i+1]<H4Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-4", 0, nAutoNum(i), 185, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-4", 0, nAutoNum(i), 185, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
            
         if(D1MA5[i]>D1MA23[i] && D1Green[i]>D1Red[i] && (D1MA5[i+1]<=D1MA23[i+1] || D1Green[i+1]<=D1Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-5", 0, nAutoNum(i), 156, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(D1MA5[i]>D1MA23[i] && D1MA5[i+1]>D1MA23[i+1] && D1Green[i]>D1Red[i] && D1Green[i+1]>D1Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-5", 0, nAutoNum(i), 156, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(D1MA5[i]<D1MA23[i] && D1Green[i]<D1Red[i] && (D1MA5[i+1]>=D1MA23[i+1] || D1Green[i+1]>=D1Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-5", 0, nAutoNum(i), 156, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(D1MA5[i]<D1MA23[i] && D1MA5[i+1]<D1MA23[i+1] && D1Green[i]<D1Red[i] && D1Green[i+1]<D1Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-5", 0, nAutoNum(i), 156, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-5", 0, nAutoNum(i), 156, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         
         if(W1MA5[i]>W1MA23[i] && W1Green[i]>W1Red[i] && (W1MA5[i+1]<=W1MA23[i+1] || W1Green[i+1]<=W1Red[i+1]) )   //signal long тенкан пересекает линию киджун вверх и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-6", 0, nAutoNum(i), 127, 24, 24, clrGreen, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(W1MA5[i]>W1MA23[i] && W1MA5[i+1]>W1MA23[i+1] && W1Green[i]>W1Red[i] && W1Green[i+1]>W1Red[i+1]) //trend long тенкан выше киджуна и кумо направлено вверх
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-6", 0, nAutoNum(i), 127, 24, 24, clrGreenYellow, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(W1MA5[i]<W1MA23[i] && W1Green[i]<W1Red[i] && (W1MA5[i+1]>=W1MA23[i+1] || W1Green[i+1]>=W1Red[i+1])) //signal short тенкан пересекает линию киджун вниз и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-6", 0, nAutoNum(i), 127, 24, 24, clrRed, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else if(W1MA5[i]<W1MA23[i] && W1MA5[i+1]<W1MA23[i+1] && W1Green[i]<W1Red[i] && W1Green[i+1]<W1Red[i+1]) //trend short  тенкан ниже киджуна и кумо направлено вниз
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-6", 0, nAutoNum(i), 127, 24, 24, clrOrange, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
         else //nothing
            RectLabelCreate(ChartID(), "InfoRCT"+sAutoNum(i)+"-6", 0, nAutoNum(i), 127, 24, 24, clrDimGray, BORDER_RAISED, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
      }
   }
}

string sAutoNum(int n){
   switch(n){
      case 0:return "8";
      case 1:return "7";
      case 2:return "6";
      case 3:return "5";
      case 4:return "4";
      case 5:return "3";
      case 6:return "2";
      case 7:return "1";
   }
   return "";
}

int nAutoNum(int n){
   switch(n){
      case 0:return 241;
      case 1:return 212;
      case 2:return 183;
      case 3:return 154;
      case 4:return 125;
      case 5:return 96;
      case 6:return 67;
      case 7:return 38;      
   }
   return 0;
}

void Checking(ushort &ord, double &lts, double &lss, double &prft){
   if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS)){
            if(OrderType() == OP_BUY || OrderType() == OP_SELL){
               ord++;
               lts+=OrderLots();
               if(OrderType()==OP_BUY){
                  if(OrderTakeProfit() != 0.0)prft+=NormalizeDouble((OrderTakeProfit()-OrderOpenPrice())/MarketInfo(OrderSymbol(), MODE_POINT)*MarketInfo(OrderSymbol(), MODE_TICKVALUE)*OrderLots(), 2);
                  if(OrderStopLoss() != 0.0 && OrderStopLoss() < OrderOpenPrice())lss +=NormalizeDouble((OrderOpenPrice()-OrderStopLoss())/MarketInfo(OrderSymbol(), MODE_POINT)*MarketInfo(OrderSymbol(), MODE_TICKVALUE)*OrderLots()*(-1), 2);        
               }
               else if(OrderType()==OP_SELL){
                  if(OrderTakeProfit() != 0.0)prft+=NormalizeDouble((OrderTakeProfit()-OrderOpenPrice())/MarketInfo(OrderSymbol(), MODE_POINT)*MarketInfo(OrderSymbol(), MODE_TICKVALUE)*OrderLots()*(-1), 2);
                  if(OrderStopLoss() != 0.0 && OrderStopLoss() > OrderOpenPrice())lss +=NormalizeDouble((OrderOpenPrice()-OrderStopLoss())/MarketInfo(OrderSymbol(), MODE_POINT)*MarketInfo(OrderSymbol(), MODE_TICKVALUE)*OrderLots(), 2);   
               }
            }
         }         
      }
   }
}

void DrawTable(){
   RectLabelCreate(ChartID(), "InfoTBL0-0", 0, 5, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-1", 0, 5, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-2", 0, 5, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-3", 0, 5, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-4", 0, 5, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-5", 0, 5, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-6", 0, 5, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   
   RectLabelCreate(ChartID(), "InfoTBL1-0", 0, 35, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-1", 0, 35, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-2", 0, 35, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-3", 0, 35, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-4", 0, 35, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-5", 0, 35, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-6", 0, 35, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   
   RectLabelCreate(ChartID(), "InfoTBL2-0", 0, 64, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-1", 0, 64, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-2", 0, 64, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-3", 0, 64, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-4", 0, 64, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-5", 0, 64, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-6", 0, 64, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   
   RectLabelCreate(ChartID(), "InfoTBL3-0", 0, 93, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-1", 0, 93, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-2", 0, 93, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-3", 0, 93, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-4", 0, 93, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-5", 0, 93, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-6", 0, 93, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);

   RectLabelCreate(ChartID(), "InfoTBL4-0", 0, 122, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL4-1", 0, 122, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL4-2", 0, 122, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL4-3", 0, 122, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL4-4", 0, 122, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL4-5", 0, 122, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL4-6", 0, 122, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);

   RectLabelCreate(ChartID(), "InfoTBL5-0", 0, 151, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL5-1", 0, 151, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL5-2", 0, 151, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL5-3", 0, 151, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL5-4", 0, 151, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL5-5", 0, 151, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL5-6", 0, 151, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);

   
   RectLabelCreate(ChartID(), "InfoTBL6-0", 0, 180, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL6-1", 0, 180, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL6-2", 0, 180, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL6-3", 0, 180, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL6-4", 0, 180, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL6-5", 0, 180, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL6-6", 0, 180, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);

   RectLabelCreate(ChartID(), "InfoTBL7-0", 0, 209, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL7-1", 0, 209, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL7-2", 0, 209, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL7-3", 0, 209, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL7-4", 0, 209, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL7-5", 0, 209, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL7-6", 0, 209, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);

   RectLabelCreate(ChartID(), "InfoTBL8-0", 0, 238, 304, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL8-1", 0, 238, 275, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL8-2", 0, 238, 246, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL8-3", 0, 238, 217, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL8-4", 0, 238, 188, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL8-5", 0, 238, 159, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL8-6", 0, 238, 130, 30, 30, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);

   LabelCreate(    ChartID(), "InfoTXT0-0", 0, 13, 298, CORNER_LEFT_LOWER, "M1", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-1", 0, 8, 268, CORNER_LEFT_LOWER, "M15", "Arial", 10, clrBlack);   
   LabelCreate(    ChartID(), "InfoTXT0-2", 0, 8, 240, CORNER_LEFT_LOWER, "M30", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-3", 0, 13, 211, CORNER_LEFT_LOWER, "H1", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-4", 0, 14, 182, CORNER_LEFT_LOWER, "H4", "Arial", 10, clrBlack);   
   LabelCreate(    ChartID(), "InfoTXT0-5", 0, 14, 153, CORNER_LEFT_LOWER, "D1", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-6", 0, 13, 122, CORNER_LEFT_LOWER, "W1", "Arial", 10, clrBlack);
   
   RectLabelCreate(ChartID(), "InfoTBL0-7", 0, 5, 101,31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-8", 0, 5, 82, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-9", 0, 5, 63, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-10",0, 5, 44, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-11",0, 5, 25, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   
   LabelCreate(    ChartID(), "InfoTXT0-7", 0, 16, 100,CORNER_LEFT_LOWER, "1", "Arial", 10, clrBlack);   
   LabelCreate(    ChartID(), "InfoTXT0-8", 0, 16, 81, CORNER_LEFT_LOWER, "2", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-9", 0, 16, 62, CORNER_LEFT_LOWER, "3", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-10",0, 16, 43, CORNER_LEFT_LOWER, "4", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-11",0, 16, 24, CORNER_LEFT_LOWER, "5", "Arial", 10, clrBlack);
   
   RectLabelCreate(ChartID(), "InfoTBL1-7", 0, 35, 101,155, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);   
   RectLabelCreate(ChartID(), "InfoTBL1-8", 0, 35, 82, 155, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-9", 0, 35, 63, 155, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-10",0, 35, 44, 155, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-11",0, 35, 25, 155, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
      
   LabelCreate(    ChartID(), "InfoTXT1-7", 0, 40, 100,CORNER_LEFT_LOWER, "Открытые позиции", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-8", 0, 40, 81, CORNER_LEFT_LOWER, "Общий объём", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-9", 0, 40, 62, CORNER_LEFT_LOWER, "Потенциальный убыток", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-10",0, 40, 43, CORNER_LEFT_LOWER, "Потенциальная прибыль", "Arial", 10, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-11",0, 40, 24, CORNER_LEFT_LOWER, "Риск", "Arial", 10, clrBlack);
      
   RectLabelCreate(ChartID(), "InfoTBL2-7", 0, 188, 101,80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-8", 0, 188, 82, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-9", 0, 188, 63, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-10",0, 188, 44, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-11",0, 188, 25, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
}

bool RectLabelCreate(const long             chart_ID=0,               // ID графика 
                     const string           name="RectLabel",         // имя метки 
                     const int              sub_window=0,             // номер подокна 
                     const int              x=0,                      // координата по оси X 
                     const int              y=0,                      // координата по оси Y 
                     const int              width=50,                 // ширина 
                     const int              height=18,                // высота 
                     const color            back_clr=C'236,233,216',  // цвет фона 
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // тип границы 
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                     const color            clr=clrRed,               // цвет плоской границы (Flat) 
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы 
                     const int              line_width=1,             // толщина плоской границы 
                     const bool             back=false,               // на заднем плане 
                     const bool             selection=false,          // выделить для перемещений 
                     const bool             hidden=true,              // скрыт в списке объектов 
                     const long             z_order=0)                // приоритет на нажатие мышью 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим прямоугольную метку 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать прямоугольную метку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размеры метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим тип границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим цвет плоской рамки (в режиме Flat) 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии плоской рамки 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину плоской границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
}

bool LabelCreate(const long              chart_ID=0,               // ID графика 
                 const string            name="Label",             // имя метки 
                 const int               sub_window=0,             // номер подокна 
                 const int               x=0,                      // координата по оси X 
                 const int               y=0,                      // координата по оси Y 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                 const string            text="Label",             // текст 
                 const string            font="Arial",             // шрифт 
                 const int               font_size=10,             // размер шрифта 
                 const color             clr=clrRed,               // цвет 
                 const double            angle=0.0,                // наклон текста 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // способ привязки 
                 const bool              back=false,               // на заднем плане 
                 const bool              selection=false,          // выделить для перемещений 
                 const bool              hidden=true,              // скрыт в списке объектов 
                 const long              z_order=0)                // приоритет на нажатие мышью 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим текстовую метку 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать текстовую метку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим текст 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- установим угол наклона текста 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
//--- установим способ привязки 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- установим цвет 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
} 
  
bool TrendCreate(const long            chart_ID=0,        // ID графика 
                 const string          name="TrendLine",  // имя линии 
                 const int             sub_window=0,      // номер подокна 
                 datetime              time1=0,           // время первой точки 
                 double                price1=0,          // цена первой точки 
                 datetime              time2=0,           // время второй точки 
                 double                price2=0,          // цена второй точки 
                 const color           clr=clrRed,        // цвет линии 
                 const ENUM_LINE_STYLE style=STYLE_DASH, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=false,    // выделить для перемещений 
                 const bool            ray_right=false,   // продолжение линии вправо 
                 const bool            hidden=true,       // скрыт в списке объектов 
                 const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- установим координаты точек привязки, если они не заданы
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим трендовую линию по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать линию тренда! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль отображения линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- включим (true) или отключим (false) режим продолжения отображения линии вправо 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 

bool MarkCreate(const long                chart_ID=0,        // ID графика 
                    const string          name="ArrowBuy",   // имя знака 
                    const int             sub_window=0,      // номер подокна
                    ENUM_OBJECT           obj = OBJ_ARROW_BUY, 
                    datetime              time=0,            // время точки привязки 
                    double                price=0,           // цена точки привязки 
                    const color           clr=C'3,95,172',   // цвет знака 
                    const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии (при выделении) 
                    const int             width=1,           // размер линии (при выделении) 
                    const bool            back=false,        // на заднем плане 
                    const bool            selection=false,   // выделить для перемещений 
                    const bool            hidden=true,       // скрыт в списке объектов 
                    const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- установим координаты точки привязки, если они не заданы 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим знак 
   if(!ObjectCreate(chart_ID,name,obj,sub_window,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать знак \"Buy\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет знака 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии (при выделении) 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим размер линии (при выделении) 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения знака мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установи приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 