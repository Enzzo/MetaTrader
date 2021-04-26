// ApM Modded v006 05/11/2012
#property copyright "Copyleft 2012"
#property link      "http://www.net"
#include <ShowSpread.mqh>
SpreadController sc;

string modver = "M6 (TLP public)";
input bool ShowTradeComment            = FALSE;
//extern bool RealtimeChartUpdate = FALSE;
input int      Spread                  = 1;    //Спред, допустимый для торговли
input double   Lots                    = 0.01;  //Объем
input double   MultiLotsFactor         = 1.6;   //Множитель лота
input double   StepLots                = 15.0;  //Размер сетки
input double   TakeProfit              = 23.0;
input bool     UseTrailing             = FALSE;
input double   TrailStart              = 38.0;
input double   TrailStop               = 18.0;
input int      MaxOpenOrders           = 15;
input bool     SafeEquityStopOut       = FALSE;
input double   SafeEquityRisk          = 0.5;
input double   Slippage                = 3.0;
input int      MagicNumber             = 2024536;
input bool     FreezeAfterTP           = FALSE;
input bool     Close_All_Orders        = FALSE;
input string   TradeComment            = "FXGT";
input string   ______________          = "Планировщик:";
input int      StartHour = 0;
input int      StartMinute = 0;
input int      StopHour = 0;
input int      StopMinute = 0;
input int      StartingTradeDay = 0;
input int      EndingTradeDay = 7;
/*extern*/ bool UseLotFix = TRUE;
bool gi_184 = FALSE;
double gd_188 = 48.0;
double gd_196 = 500.0;
int lotDigits = 0;
bool gi_212 = TRUE;
bool gi_216 = FALSE;
int gi_220 = 1;
double gd_224;
double gd_232;
double gd_240;
double gd_248;
double gd_256;
double gd_264;
double gd_272;
double slippage;
bool gi_HaveNewOpenOrders;
int gt_292 = 0;
int gi_296;
int gi_300 = 0;
double gd_304;
int gi_312 = 0;
int gi_OrdersOpen;
double gd_320 = 0.0;
bool gi_328 = FALSE;
bool gi_332 = FALSE;
bool gi_336 = FALSE;
int gi_340;
bool gi_344 = FALSE;
int gi_348 = 0;
int gi_352 = 0;
double gd_356;
double gd_364;
string gs_off_372 = "OFF";
string gs_live_380 = "REAL";
string gs_396 = "";
bool canTrade = TRUE;
bool gi_412 = TRUE;
int accountNumber = 0;
int gi_420;
int gStartMinutes, gStopMinutes;
double PipToTP, MaxDD = 0;

//+------------------------------------------------------------------------+
//|   
//|   IsTradeTime()
//|   Используется для планировщика
//|   Разрешено торговать, или нет
//|   
//|   AllowTrade - разрешено торговать
//|   
bool IsTradeTime() {

   if(!sc.CompareSpread(Spread))
      return false;
   
  if (FreezeAfterTP) return(false);
  bool AllowTrade = true;
  gStartMinutes = 60 * StartHour + StartMinute;
  gStopMinutes = 60 * StopHour + StopMinute;
  int day = DayOfWeek();
  if (day < StartingTradeDay || day > EndingTradeDay) AllowTrade = false;
  int minuntes = 60 * TimeHour(TimeCurrent()) + TimeMinute(TimeCurrent());
  if (day <= StartingTradeDay && gStartMinutes >= minuntes) AllowTrade = false;
  if (day >= EndingTradeDay && gStopMinutes < minuntes) AllowTrade = false;
  return(AllowTrade);   
}   

int OnInit() {
   if (Digits == 2 || Digits == 4) gi_420 = 1;
   else gi_420 = 10;
   accountNumber = AccountNumber();
   slippage = MarketInfo(Symbol(), MODE_SPREAD) * Point * gi_420;
   double minlot = MarketInfo(Symbol(), MODE_MINLOT);
   
   if (minlot == 0.001)
      lotDigits = 3;
   if (minlot == 0.01)
      lotDigits = 2;
   if (minlot == 0.1)
      lotDigits = 1;
   if (minlot == 1.0)
      lotDigits = 0;   
  
   if (SafeEquityStopOut) gs_off_372 = "ON";
   if (IsDemo()) gs_live_380 = "DEMO";
   if (Period() != PERIOD_M1) {
      Print("FGT ERROR :: Invalid Timeframe, Please switch to M1.");
      Alert("FGT ERROR :: ", " Invalid Timeframe, Please switch to M1.");
      gs_396 = "Invalid Timeframe. FGT works on M1";
      canTrade = FALSE;
   }
   return(INIT_SUCCEEDED);
}

int deinit() {
   sc.DestroyInfo();
   Comment("");
   if (ObjectFind("BG") >= 0) ObjectDelete("BG");
   if (ObjectFind("BG1") >= 0) ObjectDelete("BG1");
   if (ObjectFind("BG2") >= 0) ObjectDelete("BG2");
   if (ObjectFind("BG3") >= 0) ObjectDelete("BG3");
   if (ObjectFind("BG4") >= 0) ObjectDelete("BG4");
   if (ObjectFind("BG5") >= 0) ObjectDelete("BG5");
   if (ObjectFind("NAME") >= 0) ObjectDelete("NAME");
   return (0);
}

int start() {
   sc.ShowSpread(1, 10, 15, Spread);
   if (Close_All_Orders == TRUE) {deletePrevOrders(); return (0);}

   int lia_0[1];
   int lia_4[1];
   double ld_12;
   double ld_20;
   double ld_28;
   double ld_36;
   int li_52;
   
   if (UseTrailing) Tral(TrailStart, TrailStop, gd_240);
   if (gi_184) {
      if (TimeCurrent() >= gi_296) {
         deletePrevOrders();
         Print("Closed All Trades Due To Server TimeOut");
      }
   }
   if (gt_292 == Time[0]) return (0);
   gt_292 = Time[0];
   double ld_44 = f0_6();
   if (SafeEquityStopOut) {
      if (ld_44 < 0.0 && MathAbs(ld_44) > SafeEquityRisk / 100.0 * f0_9()) {
         deletePrevOrders();
         Print("Closed All due to EQUITY STOP-OUT");
         gi_344 = FALSE;
      }
   }
   gi_HaveNewOpenOrders = FALSE;
   gi_OrdersOpen = f0_16();
   //if (gi_OrdersOpen == 0) gi_HaveNewOpenOrders = FALSE;
   for (gi_312 = OrdersTotal() - 1; gi_312 >= 0; gi_312--) {
      OrderSelect(gi_312, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            gi_332 = TRUE;
            gi_336 = FALSE;
            ld_12 = OrderLots();
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            gi_332 = FALSE;
            gi_336 = TRUE;
            ld_20 = OrderLots();
            break;
         }
      }
   }
   gi_328 = FALSE;
   if (gi_OrdersOpen > 0 && gi_OrdersOpen <= MaxOpenOrders) {
      RefreshRates();
      gd_264 = f0_2();
      gd_272 = f0_7();
      li_52 = func1(gi_332, gi_336, Bid, Ask, gd_264, gd_272, Point, StepLots, gi_420);
      if (li_52 == 1) gi_328 = TRUE;
      gs_396 = f0_12(3);
   }
   if (gi_OrdersOpen > 1 && UseLotFix) gi_300 = gi_OrdersOpen-1;
   gd_304 = f0_14(OP_SELL);
   if (gi_OrdersOpen < 1) {
      gi_336 = FALSE;
      gi_332 = FALSE;
      gi_328 = TRUE;
      gd_232 = AccountEquity();
   }
   if (gi_328) {
      gd_264 = f0_2();
      gd_272 = f0_7();
      if (gi_336) {
         if (gi_216) {
            f0_1(0, 1);
            gd_304 = NormalizeDouble(MultiLotsFactor * ld_20, lotDigits);
         } else gd_304 = f0_14(OP_SELL);
         if (gi_212) {
            gi_300 = gi_OrdersOpen;
            if (gd_304 > 0.0) {
               RefreshRates();
               gi_340 = fOrderSend(1, gd_304, Bid, Slippage, Ask, 0, 0, TradeComment + "-" + gi_300, MagicNumber, 0, HotPink);
               if (gi_340 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               gd_272 = f0_7();
               gi_328 = FALSE;
               gi_344 = TRUE;
            }
         }
      } else {
         if (gi_332) {
            if (gi_216) {
               f0_1(1, 0);
               gd_304 = NormalizeDouble(MultiLotsFactor * ld_12, lotDigits);
            } else gd_304 = f0_14(OP_BUY);
            if (gi_212) {
               gi_300 = gi_OrdersOpen;
               if (gd_304 > 0.0) {
                  gi_340 = fOrderSend(0, gd_304, Ask, Slippage, Bid, 0, 0, TradeComment + "-" + gi_300, MagicNumber, 0, Lime);
                  if (gi_340 < 0) {
                     Print("Error: ", GetLastError());
                     return (0);
                  }
                  gd_264 = f0_2();
                  gi_328 = FALSE;
                  gi_344 = TRUE;
               }
            }
         }
      }
   }
   if (gi_328 && gi_OrdersOpen < 1  && IsTradeTime()) {
      ld_28 = iClose(Symbol(), 0, 2);
      ld_36 = iClose(Symbol(), 0, 1);
      gd_248 = Bid;
      gd_256 = Ask;
      if ((!gi_336) && !gi_332) {
         gi_300 = gi_OrdersOpen;
         if (ld_28 > ld_36) {
            gd_304 = f0_14(OP_SELL);
            if (gd_304 > 0.0) {
               gi_340 = fOrderSend(1, gd_304, gd_248, Slippage, gd_248, 0, 0, TradeComment + " " + MagicNumber + "-" + gi_300, MagicNumber, 0, HotPink);
               if (gi_340 < 0) {
                  Print(gd_304, "Error: ", GetLastError());
                  return (0);
               }
               gd_264 = f0_2();
               gi_344 = TRUE;
            }
         } else {
            gd_304 = f0_14(OP_BUY);
            if (gd_304 > 0.0) {
               gi_340 = fOrderSend(0, gd_304, gd_256, Slippage, gd_256, 0, 0, TradeComment + " " + MagicNumber + "-" + gi_300, MagicNumber, 0, Lime);
               if (gi_340 < 0) {
                  Print(gd_304, "Error: ", GetLastError());
                  return (0);
               }
               gd_272 = f0_7();
               gi_344 = TRUE;
            }
         }
      }
      if (gi_340 > 0) gi_296 = TimeCurrent() + 60.0 * (60.0 * gd_188);
      gi_328 = FALSE;
   }
   gi_OrdersOpen = f0_16();
   gd_240 = 0;
   double ld_56 = 0;
   for (gi_312 = OrdersTotal() - 1; gi_312 >= 0; gi_312--) {
      OrderSelect(gi_312, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            gd_240 += OrderOpenPrice() * OrderLots();
            ld_56 += OrderLots();
         }
      }
   }
   if (gi_OrdersOpen > 0) gd_240 = NormalizeDouble(gd_240 / ld_56, Digits);
   if (gi_344) {
      for (gi_312 = OrdersTotal() - 1; gi_312 >= 0; gi_312--) {
         OrderSelect(gi_312, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               gd_224 = gd_240 + TakeProfit * Point * gi_420;
               gd_320 = gd_240 - gd_196 * Point * gi_420;
               gi_HaveNewOpenOrders = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               gd_224 = gd_240 - TakeProfit * Point * gi_420;
               gd_320 = gd_240 + gd_196 * Point * gi_420;
               gi_HaveNewOpenOrders = TRUE;
            }
         }
      }
   }
   if (gi_344) {
      if (gi_HaveNewOpenOrders == TRUE) {
         for (gi_312 = OrdersTotal() - 1; gi_312 >= 0; gi_312--) {
            OrderSelect(gi_312, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (NormalizeDouble(gd_224, Digits) == NormalizeDouble(OrderTakeProfit(), Digits)) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) OrderModify(OrderTicket(), gd_240, OrderStopLoss(), gd_224, 0, Yellow);
            Sleep(3000);
            if (OrderTakeProfit() > 0) gi_344 = FALSE;
         }
      }
   }
   ShowTable();
   return (0);
}


//+------------------------------------------------------------------------+
//|   
//|   ShowTable()
//|   Отображает информационную таблицу  слева
//|   
void ShowTable() {
   if (ShowTradeComment) {
      if (IsTesting() && !IsVisualMode()) return;
      if (ObjectFind("BG") < 0) {
         ObjectCreate("BG", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("BG", "g", 210, "Webdings", Orange);
         ObjectSet("BG", OBJPROP_CORNER, 0);
         ObjectSet("BG", OBJPROP_BACK, TRUE);
         ObjectSet("BG", OBJPROP_XDISTANCE, 0);
         ObjectSet("BG", OBJPROP_YDISTANCE, 15);
      }
      if (ObjectFind("BG1") < 0) {
         ObjectCreate("BG1", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("BG1", "g", 210, "Webdings", DimGray);
         ObjectSet("BG1", OBJPROP_BACK, FALSE);
         ObjectSet("BG1", OBJPROP_XDISTANCE, 0);
         ObjectSet("BG1", OBJPROP_YDISTANCE, 42);
      }
      if (ObjectFind("BG2") < 0) {
         ObjectCreate("BG2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("BG2", "g", 210, "Webdings", DimGray);
         ObjectSet("BG2", OBJPROP_CORNER, 0);
         ObjectSet("BG2", OBJPROP_BACK, TRUE);
         ObjectSet("BG2", OBJPROP_XDISTANCE, 0);
         ObjectSet("BG2", OBJPROP_YDISTANCE, 42);
      }
      if (ObjectFind("NAME") < 0) {
         ObjectCreate("NAME", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("NAME", "FOREX GRID TRADER EA - " + Symbol(), 9, "Arial Bold", White);
         ObjectSet("NAME", OBJPROP_CORNER, 0);
         ObjectSet("NAME", OBJPROP_BACK, FALSE);
         ObjectSet("NAME", OBJPROP_XDISTANCE, 5);
         ObjectSet("NAME", OBJPROP_YDISTANCE, 23);
      }
      if (ObjectFind("BG3") < 0) {
         ObjectCreate("BG3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("BG3", "g", 110, "Webdings", DimGray);
         ObjectSet("BG3", OBJPROP_CORNER, 0);
         ObjectSet("BG3", OBJPROP_BACK, TRUE);
         ObjectSet("BG3", OBJPROP_XDISTANCE, 0);
         ObjectSet("BG3", OBJPROP_YDISTANCE, 73);
      }
      if (ObjectFind("BG5") < 0) {
         ObjectCreate("BG5", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("BG5", "g", 210, "Webdings", DimGray);
         ObjectSet("BG5", OBJPROP_CORNER, 0);
         ObjectSet("BG5", OBJPROP_BACK, FALSE);
         ObjectSet("BG5", OBJPROP_XDISTANCE, 0);
         ObjectSet("BG5", OBJPROP_YDISTANCE, 73);
      }
      f0_3();
   }
}

double f0_10(double ad_0) {
   return (NormalizeDouble(ad_0, Digits));
}

int f0_1(bool ai_0 = TRUE, bool ai_4 = TRUE) {
   int li_8 = 0;
   for (int li_12 = OrdersTotal() - 1; li_12 >= 0; li_12--) {
      if (OrderSelect(li_12, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY && ai_0) {
               RefreshRates();
               if (!IsTradeContextBusy()) {
                  if (!OrderClose(OrderTicket(), OrderLots(), f0_10(Bid), 5, CLR_NONE)) {
                     Print("Error close BUY " + OrderTicket());
                     li_8 = -1;
                  }
               } else {
                  if (gi_348 == iTime(NULL, 0, 0)) return (-2);
                  gi_348 = iTime(NULL, 0, 0);
                  Print("Need close BUY " + OrderTicket() + ". Trade Context Busy");
                  return (-2);
               }
            }
            if (OrderType() == OP_SELL && ai_4) {
               RefreshRates();
               if (!IsTradeContextBusy()) {
                  if (!(!OrderClose(OrderTicket(), OrderLots(), f0_10(Ask), 5, CLR_NONE))) continue;
                  Print("Error Closing SELL Trade : " + OrderTicket());
                  li_8 = -1;
                  continue;
               }
               if (gi_352 == iTime(NULL, 0, 0)) return (-2);
               gi_352 = iTime(NULL, 0, 0);
               Print("Need to close SELL trade : " + OrderTicket() + ". Trade Context Busy");
               return (-2);
            }
         }
      }
   }
   return (li_8);
}

double f0_14(int ai_0) {
   double ld_4;
   int li_12;
   switch (gi_220) {
   case 0:
      ld_4 = Lots;
      break;
   case 1:
      ld_4 = NormalizeDouble(Lots * MathPow(MultiLotsFactor, gi_300), lotDigits);
      break;
   case 2:
      li_12 = 0;
      ld_4 = Lots;
      for (int li_20 = OrdersHistoryTotal() - 1; li_20 >= 0; li_20--) {
         if (!(OrderSelect(li_20, SELECT_BY_POS, MODE_HISTORY))) return (-3);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (li_12 < OrderCloseTime()) {
               li_12 = OrderCloseTime();
               if (OrderProfit() < 0.0) {
                  ld_4 = NormalizeDouble(OrderLots() * MultiLotsFactor, lotDigits);
                  continue;
               }
               ld_4 = Lots;
               continue;
               return (-3);
            }
         }
      }
   }
   if (AccountFreeMarginCheck(Symbol(), ai_0, ld_4) <= 0.0) return (-1);
   if (GetLastError() == 134/* NOT_ENOUGH_MONEY */) return (-2);
   return (ld_4);
}

int f0_16() {
   PipToTP = 0;
   int li_0 = 0;
   for (int li_4 = OrdersTotal() - 1; li_4 >= 0; li_4--) {
      OrderSelect(li_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) li_0++;
         if (OrderTakeProfit() == 0) {gi_344 = TRUE; gi_HaveNewOpenOrders = TRUE;}
         if (OrderTakeProfit() > 0.0 && PipToTP == 0) {
         if (OrderType() == OP_SELL) PipToTP = (Ask - OrderTakeProfit() ) / Point / gi_420;
         if (OrderType() == OP_BUY) PipToTP = (OrderTakeProfit() - Bid) / Point / gi_420;}
   }
   return (li_0);
}

void deletePrevOrders() {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Blue);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Red);
         }
         Sleep(1000);
      }
   }
}

int fOrderSend(int ai_0, double ad_4, double ad_12, int ai_20, double ad_24, int ai_32, int ai_36, string as_40, int ai_48, int ai_52, color ai_56) {
   if (gi_OrdersOpen >= MaxOpenOrders) return 0;
   int li_60 = 0;
   int li_64 = 0;
   int li_68 = 0;
   int li_72 = 100;
   switch (ai_0) {
   case 0:
      for (li_68 = 0; li_68 < li_72; li_68++) {
         RefreshRates();
         li_60 = OrderSend(Symbol(), OP_BUY, ad_4, Ask, ai_20, f0_11(Bid, ai_32), f0_17(Ask, ai_36), as_40, ai_48, ai_52, ai_56);
         li_64 = GetLastError();
         if (li_64 == 0/* NO_ERROR */) break;
         if (!((li_64 == 4/* SERVER_BUSY */ || li_64 == 137/* BROKER_BUSY */ || li_64 == 146/* TRADE_CONTEXT_BUSY */ || li_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (li_68 = 0; li_68 < li_72; li_68++) {
         li_60 = OrderSend(Symbol(), OP_SELL, ad_4, Bid, ai_20, f0_0(Ask, ai_32), f0_5(Bid, ai_36), as_40, ai_48, ai_52, ai_56);
         li_64 = GetLastError();
         if (li_64 == 0/* NO_ERROR */) break;
         if (!((li_64 == 4/* SERVER_BUSY */ || li_64 == 137/* BROKER_BUSY */ || li_64 == 146/* TRADE_CONTEXT_BUSY */ || li_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
   }
   return (li_60);
}

double f0_11(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   return (ad_0 - ai_8 * Point * gi_420);
}

double f0_0(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   return (ad_0 + ai_8 * Point * gi_420);
}

double f0_17(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   return (ad_0 + ai_8 * Point * gi_420);
}

double f0_5(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   return (ad_0 - ai_8 * Point * gi_420);
}

double f0_6() {
   double ld_0 = 0;
   for (gi_312 = OrdersTotal() - 1; gi_312 >= 0; gi_312--) {
      OrderSelect(gi_312, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) ld_0 += OrderProfit();
   }
   return (ld_0);
}

void Tral(int tStart, int tStop, double ad_8) {
   int li_16;
   double ld_20;
   double ld_28;
   if (tStop != 0) {
      for (int i = OrdersTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_BUY) {
                  li_16 = NormalizeDouble((Bid - ad_8) / Point / gi_420, 0);
                  if (li_16 < tStart) continue;
                  ld_20 = OrderStopLoss();
                  ld_28 = Bid - tStop * Point * gi_420;
                  if (ld_20 == 0.0 || (ld_20 != 0.0 && ld_28 > ld_20)) OrderModify(OrderTicket(), ad_8, ld_28, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  li_16 = NormalizeDouble((ad_8 - Ask) / Point / gi_420, 0);
                  if (li_16 < tStart) continue;
                  ld_20 = OrderStopLoss();
                  ld_28 = Ask + tStop * Point * gi_420;
                  if (ld_20 == 0.0 || (ld_20 != 0.0 && ld_28 < ld_20)) OrderModify(OrderTicket(), ad_8, ld_28, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}

double f0_9() {
   if (f0_16() == 0) gd_356 = AccountEquity();
   if (gd_356 < gd_364) gd_356 = gd_364;
   else gd_356 = AccountEquity();
   gd_364 = AccountEquity();
   return (gd_356);
}

double f0_2() {
   double ld_0;
   int li_8;
   double ld_12 = 0;
   int li_20 = 0;
   for (int li_24 = OrdersTotal() - 1; li_24 >= 0; li_24--) {
      OrderSelect(li_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
         li_8 = OrderTicket();
         if (li_8 > li_20) {
            ld_0 = OrderOpenPrice();
            ld_12 = ld_0;
            li_20 = li_8;
         }
      }
   }
   return (ld_0);
}

double f0_7() {
   double ld_0;
   int li_8;
   double ld_12 = 0;
   int li_20 = 0;
   for (int li_24 = OrdersTotal() - 1; li_24 >= 0; li_24--) {
      OrderSelect(li_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
         li_8 = OrderTicket();
         if (li_8 > li_20) {
            ld_0 = OrderOpenPrice();
            ld_12 = ld_0;
            li_20 = li_8;
         }
      }
   }
   return (ld_0);
}

void f0_3() {
   string ls_1 = "", ls_2 = "", ls_3 = "";
   string ls_0 = DoubleToStr(balanceDeviation(), 2);
   if (balanceDeviation() > MaxDD) MaxDD = balanceDeviation();
   ls_3 = "Margin Usage:                            " + DoubleToStr(100 - (AccountFreeMargin()/AccountBalance()*100),2) + "%\n";
   if (!IsTradeTime()) ls_1 = "New Trades disallowed by scheduler";
   if (FreezeAfterTP) ls_1 = "Freeze AfterTP Enabled";
   Comment("" 
      + "\n" 
      + "\n" 
      + "\n" 
      + "EXPERT VERSION: 1.0 " + modver
      + "\n" 
      + "=======================================" 
      //+ "\n" 
      //+ "-----------------------------------------------------------------------------------" 
      //+ "\n" 
      //+ "AUTHENTICATION STATUS" 
      //+ "\n" 
      //+ "-----------------------------------------------------------------------------------" 
      //+ "\n" 
      //+ "STATUS MESSAGE:   " + gs_396 
      //+ "\n" 
      //+ "-----------------------------------------------------------------------------------" 
      + "\n" 
      + "ACCOUNT INFORMATION" 
      + "\n" 
      + "-----------------------------------------------------------------------------------" 
      + "\n" 
      //+ "Account Name:                " + AccountName() 
      //+ "\n" 
      + "Account Number:             " + AccountNumber() + " (" + gs_live_380 + ")"
      + "\n" 
      //+ "Account Type:                 " + gs_live_380 
      //+ "\n" 
      + "Account Leverage:           1:" + DoubleToStr(AccountLeverage(), 0) 
      + "\n" 
      + "Account Balance:             " + DoubleToStr(AccountBalance(), 2) 
      + "\n" 
      + "Account Equity:               " + DoubleToStr(AccountEquity(), 2) 
      + "\n" 
      + "Server Time:                   " + TimeToStr(TimeCurrent(), TIME_SECONDS)
      + "\n" 
      + "-----------------------------------------------------------------------------------" 
      + "\n" 
      + "TRADE INFORMATIONS " 
      + "\n" 
      + "------------------------------------------------------------------------------------" 
      + "\n" 
      + "SAFE EQUITY STOP OUT :        " + gs_off_372 + "  @ " + DoubleToStr(SafeEquityRisk*100, 2)  + "%"
      + "\n" 
      //+ "SAFE EQUITY RISK % :             " + DoubleToStr(SafeEquityRisk, 2) 
      //+ "\n" 
      + ls_2
      + "NEXT LOT(S) :                            " + DoubleToStr(gd_304, 2)
      + "\n" 
      + "OPEN TRADES :                         " + DoubleToStr(f0_8(), 0) + " / " + MaxOpenOrders
      + "\n" 
      + "FLOATING P/L :                          " + DoubleToStr(AccountProfit(), 2) 
      + "\n"
//      + "CURRENT PROFIT:                     " + DoubleToStr(CurProfit, 2) 
//      + "\n" 
//      + "POTENTIAL PROFIT:                  " + DoubleToStr(PotProfit, 2) 
//      + "\n"
      + "Pips To TP:                                  " + DoubleToStr(PipToTP, 1) 
      + "\n"      
      + "=======================================\n"
      + "Drawdown :                               " + ls_0 + "%"
      + "\n"
      + "Drawdown (Max) :                      " + DoubleToStr(MaxDD,2) + "%"
      + "\n"
      + ls_3
      + "Total Profit/Loss :                        " + DoubleToStr(calculatePLBalance(),2) + "\n"      
      + ls_1
      );
}

double calculatePLBalance() {
   double gd_TotalPL = 0;
   int li_0 = OrdersHistoryTotal();
   for (int li_4 = 0; li_4 < li_0; li_4++) {
      OrderSelect(li_4, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber() == MagicNumber) gd_TotalPL += OrderProfit() + OrderSwap() + OrderCommission();
   }
return(gd_TotalPL);   
}

double balanceDeviation() {
   double bd;
   bd = (AccountEquity() / AccountBalance() - 1.0) / (-0.01);
   if (bd <= 0.0) return (0);
   return (bd);
}

int f0_8() {
   int li_0 = OrdersTotal();
   int li_8 = 0;
   for (int li_4 = 0; li_4 < li_0; li_4++) {
      OrderSelect(li_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_SELL || OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) li_8++;
   }
   return (li_8);
}

string f0_12(int ai_0) {
   if (ai_0 == 0) return ("HTTP Error");
   if (ai_0 == 1) return ("Account does not exist or banned");
   if (ai_0 == 2) return ("Account Activation Successful");
   if (ai_0 == 3) return ("Account Authentication Successful");
   if (ai_0 == 4) return ("Account not Activated!!!");
   if (ai_0 == 5) return ("Insert a valid CLICKBANK ID.");
   return ("Ok");
}

int func1(int a1, int a2, double a3, double a4, double a5, double a6, double a7, double a8, double a9)
{
   
   if ( a1 && a7 * a8 * a9 <= a5 - a4 ) return(1);
   if ( a2 && a3 - a6 >= a9 * a8 * a7 ) return(1);
   return(0);
}