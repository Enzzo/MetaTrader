//+------------------------------------------------------------------+
//|                                              Expert_Ichimoku.mq4 |
//|                      Copyright � 2009, MetaQuotes Software Corp. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2009, MetaQuotes Software Corp."
#property link      ""

// ������ �������� �������� ��� �������� ������� � �������� ��������� 
// ���������� �������� ������ Market Watch , - WH�, BROCO � �.�.
// �������� ���������� ���� �� (��������� �������� ������ �� �������). 
// ������������ ������ ����������� ������ �� ����� ���� ����� ����� - 
//  - ���������  �-� �.���� NumberOfBarOpenLastPos(). 


//---- input parameters

extern int     Magic=5675;
extern int     Orders =5;
extern int     StopLoss=50;
extern int     TakeProfit=100;
extern string   ___= "��������� ���. �������";
extern int Tenkan=5;
extern int Kijun=10;
extern int Senkou=20;
extern int     LipsPeriod=5;
extern int     LipsShift=3;
extern string   ____= "��������� �������� �����";
extern bool     UseTrailing = true;//����������� ���������
extern int     lMinProfit         = 40;//����� ����� ������� ���
extern int     lTrailingStop      = 50;//������ ����� ������� ���
extern int     lTrailingStep      = 5;// ��� �����
extern int     sMinProfit              = 40;//����� ����� �������� ���
extern int     sTrailingStop           = 50;//������ ����� �������� ���
extern int     sTrailingStep           = 5; //��� �����
extern string     ______= "��������� ����� MoneyManagement";
extern double    Lots = 0.01;
extern bool      MoneyManagement=true;
extern int       MarginPercent=3;
//----------------------------------
double SL,TP;
int ticket;
 double lots;
static int prevtime = 0;
//-- ������������ ������ --

#include <stderror.mqh>
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
 
if (Time[0] == prevtime) return(0); // ��� �������, � ������������� �������
   prevtime = Time[0]; // ������ ���, ���������� �����
//----
if (UseTrailing) TrailPositions(); //�������� ����
// ��������� ����������
int total, cnt;
int err;
// double lots;
// ��������� ��������� ��������� ����������� ��� ������ ������� �����
   double Ten=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_TENKANSEN,1);
   double Kij=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_KIJUNSEN,1);  
   double SpanA=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_SENKOUSPANA,1);
   double SpanB=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_SENKOUSPANB,1);
   double Chinkou=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_CHINKOUSPAN,1);
   double Ten1=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_TENKANSEN,2);
   double Kij1=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_KIJUNSEN,2);  
   double SpanA1=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_SENKOUSPANA,2);
   double SpanB1=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_SENKOUSPANB,2);
   double Chinkou1=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_CHINKOUSPAN,2);
   double Ten2=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_TENKANSEN,3);
   double Kij2=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_KIJUNSEN,3);  
   double SpanA2=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_SENKOUSPANA,3);
   double SpanB2=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_SENKOUSPANB,3);
   double Chinkou2=iIchimoku(NULL, 0,Tenkan, Kijun, Senkou, MODE_CHINKOUSPAN,3);
  total=OrdersTotal();
Comment( LotsCounting() );
//=======================================================================
  // �������� �������
  if(AccountFreeMargin()<(1000*Lots))
     {
       Print("� ��� ������������ �����. Free Margin = ", AccountFreeMargin());   
       return(0);  
     }
//============�������� �������  =======================================  
if ( NumberOfPositions(NULL , -1, Magic )<Orders ) { //����  �������� ������� ����� Orders
//==================================================================== 
  // �������� ������� ��� ���������� ������ ���
if (! NumberOfBarOpenLastPos(NULL, 0,OP_BUY, Magic)  ==0) { //������ ����. ��� �� ����� ����
  if ((Ten1<=Kij1 && Ten>Kij && Ask>SpanA1 && Ask>SpanB1 && Open[1]<Close[1]) || (Chinkou1<=Close[11] && Chinkou>Close[10] && Ask>SpanA1 && Ask>SpanB1 && Open[1]<Close[1])) //��������
     { SL=0;TP=0;
      if(StopLoss>0)   SL=Ask-Point*StopLoss;
      if(TakeProfit>0) TP=Ask+Point*TakeProfit;
      lots=LotsCounting();    
   ticket=WHCOrderSend(Symbol(),OP_BUY,lots,Ask,3,SL,TP,"��������",Magic,0,Green);
   if(ticket < 0) {
            Print("������ �������� ������ BUY #", GetLastError()); 
            Sleep(10000); 
            prevtime = Time[1]; 
            return (0); 
         } 
       }
     }
//=================================================================
// �������� ������� ��� ���������� ������ ���� 
if (! NumberOfBarOpenLastPos(NULL, 0,OP_SELL, Magic)  ==0) {//������ ����. ��� �� ����� ���� 
  if ((Ten1>=Kij1 && Ten<Kij && Bid<SpanA1 && Bid<SpanB1 && Open[1]>Close[1]) || (Chinkou1>=Open[11] && Chinkou<Open[10] && Bid<SpanA1 && Bid<SpanB1 && Open[1]>Close[1]))//�������
     { SL=0;TP=0;
      if(StopLoss>0)   SL=Bid+Point*StopLoss;
      if(TakeProfit>0) TP=Bid-Point*TakeProfit;
      lots=LotsCounting(); 
   ticket=WHCOrderSend(Symbol(),OP_SELL,lots,Bid,3,SL,TP,"�������",Magic,0,Red);
   if(ticket < 0){
            Print("������ �������� ������ SELL #", GetLastError()); 
            Sleep(10000);  
            prevtime = Time[1]; 
            return (0); 
         } 
       }
     }
//=====================================================================
 }    //����  �������� ������� ����� Orders 
//============ ����� ����� �������� ������� ===========================
 
//================�������� �������=====================================
//----------------------------------------------------------------------
   for ( int v = OrdersTotal() - 1; v >= 0; v -- )                  {       
      if (OrderSelect(v, SELECT_BY_POS, MODE_TRADES))                {           
        if (OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)     { 
//-----------------------------------------------------                  
if (OrderType() == OP_BUY) { 
      if((Ten1>=Kij1 && Ten<Kij && Bid<SpanA1 && Bid<SpanB1 && Open[1]>Close[1]) || (Chinkou1>=Open[11] && Chinkou<Open[10] && Bid<SpanA1 && Bid<SpanB1 && Open[1]>Close[1]) && OrderProfit( ) >=0)     {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,Yellow); // ��������� �������
                // return(0); // �������         
              }   }  
//--------------------------------------------------------
if (OrderType() == OP_SELL) { 
      if((Ten1<=Kij1 && Ten>Kij && Ask>SpanA1 && Ask>SpanB1 && Open[1]<Close[1]) || (Chinkou1<=Close[11] && Chinkou>Close[10] && Ask>SpanA1 && Ask>SpanB1 && Open[1]<Close[1])&& OrderProfit( ) >=0) {
               OrderClose(OrderTicket(),OrderLots(),Ask,3,Yellow); // ��������� �������
                // return(0); // �������
              }   }  
//-------------------------------------------------------                       
    }  // Symbol()  
  } // select
} //total 
//================== ����� ����� ��������  =============================
   
  return(0);
  }
//������������������ ����� ������� int start() ������������������������
 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void TrailPositions() {// ������� �������� ����
  int Orders = OrdersTotal();
  for (int i=0; i<Orders; i++)                                      {
    if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))) continue;
    if (OrderSymbol() != Symbol()) continue;    
     if (OrderType() == OP_BUY && OrderMagicNumber()==Magic)           {
      if (Bid-OrderOpenPrice() > lMinProfit*Point)                      {
        if (OrderStopLoss() < Bid-(lTrailingStop+lTrailingStep-1)*Point) {
          OrderModify(OrderTicket(), OrderOpenPrice(), Bid-lTrailingStop*Point,
                                                     OrderTakeProfit(), 0, Blue);
        }}}
    if (OrderType() == OP_SELL && OrderMagicNumber()==Magic)                 {
      if (OrderOpenPrice()-Ask > sMinProfit*Point)                            {
        if (OrderStopLoss() > Ask+(sTrailingStop+sTrailingStep-1)*Point 
                                                       || OrderStopLoss() == 0) {
          OrderModify(OrderTicket(), OrderOpenPrice(), Ask+sTrailingStop*Point,
                                                      OrderTakeProfit(), 0, Blue);
        }}}}  }
//------------------------------------------------------------------------------+
//======================== ���� �� ============================================== 
  //�����������������������������������������������������������������������������  
double LotsCounting() { double lots=Lots;
   if (MoneyManagement)      {
      double lotsize=MarketInfo(Symbol(),MODE_LOTSIZE);
      double freemargin=AccountFreeMargin();
      lots=0; if (lotsize>0) lots=NormalizeDouble((MarginPercent*freemargin/lotsize),1);
      Comment(NormalizeDouble((MarginPercent*freemargin/lotsize),1));    }
   if (lots>5) lots=4.9; if (lots<0.1) lots=0.1;return (lots);   }
//�������������������������������������������������������������������������������
// ������� orders for WHC - 
//���  �������� ������� � �������� ��������� ���������� �������� ������ Market Watch
int WHCOrderSend(string symbol, 
                 int cmd, 
                 double volume, 
                 double price, 
                 int slippage, 
                 double stoploss, 
                 double takeprofit, 
                 string comment, 
                 int magic, 
                 datetime expiration, 
                 color arrow_color)
{
   int ticket = OrderSend(symbol,cmd, volume, price, slippage, 0, 0, comment, magic, expiration, arrow_color);   
   int check = -1;
   if (ticket > 0 && (stoploss != 0 || takeprofit != 0)) {
      if (!OrderModify(ticket, price, stoploss, takeprofit,expiration, arrow_color)) {
         check = GetLastError();
         if (check != ERR_NO_ERROR) {
            Print("OrderModify error: ", ErrorDescription(check));
         }
      }
   } else {
      check = GetLastError();
      if (check != ERR_NO_ERROR){
         Print("OrderSend error: ",ErrorDescription(check));
      }
   }
   return (ticket);
}

//+----------------------------------------------------------------------------+
//|                                                                            |
//|  �������� : ���������� ���������� �������.                                 |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������   (""   - ����� ������,                   |
//|                                     NULL - ������� ������)                 |
//|    op - ��������                   (-1   - ����� �������)                  |
//|    mn - MagicNumber                (-1   - ����� �����)                    |
//+----------------------------------------------------------------------------+
int NumberOfPositions(string sy="", int op=-1, int mn=-1) {
  int i, k=OrdersTotal(), kp=0;

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==sy || sy=="") {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (op<0 || OrderType()==op) {
            if (mn<0 || OrderMagicNumber()==mn) kp++;
          }
        }
      }
    }
  }
  return(kp);
}

//+----------------------------------------------------------------------------+
//|                                                                            |
//|  �������� : ���������� ����� ���� �������� ��������� ������� ��� -1.       |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������   ("" ��� NULL - ������� ������)          |
//|    tf - ���������                  (    0       - ������� ���������)       |
//|    op - ��������                   (   -1       - ����� �������)           |
//|    mn - MagicNumber                (   -1       - ����� �����)             |
//+----------------------------------------------------------------------------+
int NumberOfBarOpenLastPos(string sy="0", int tf=0, int op=-1, int mn=-1) {
  datetime t;
  int      i, k=OrdersTotal();

  if (sy=="" || sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==sy) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (op<0 || OrderType()==op) {
            if (mn<0 || OrderMagicNumber()==mn) {
              if (t<OrderOpenTime()) t=OrderOpenTime();
            }
          }
        }
      }
    }
  }
  return(iBarShift(sy, tf, t, True));
}