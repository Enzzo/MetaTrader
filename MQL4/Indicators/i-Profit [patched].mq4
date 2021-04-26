//+----------------------------------------------------------------------------+
//|                                                              i-Profit.mq4  |
//|                                                                            |
//|                                                    ��� ����� �. aka KimIV  |
//|                                                       http://www.kimiv.ru  |
//|                                                                            |
//|  12.05.2008  ���������:                                                    |
//|              - ������� �������                                             |
//|              - ������� �� �������                                          |
//|              - ������� �� �����                                            |
//|              - ������� �� ��������� ��������� ����                         |
//|              - ������� �� ������� ������                                   |
//|              - ������� �� ������� �����                                    |
//|              - ������� �� ������� �������                                  |
//|              - ������� �� ������� ���                                      |
//|  04.02.2009  �������� ������� ������� � �������.                           |
//+----------------------------------------------------------------------------+
#property copyright "��� ����� �. aka KimIV"
#property link      "http://www.kimiv.ru"
#property indicator_chart_window

//------- ������� ��������� ���������� ----------------------------------------+
extern int   eiPercent = 5;            // ������ �������� ������� ������������:
                                       //  0 - �������� �������
                                       //  1 - ������� �� ������ ���
                                       //  2 - ������� �� ������ ������
                                       //  3 - ������� �� ������ ������
                                       //  4 - ������� �� ������ ��������
                                       //  5 - ������� �� ������ ����
extern int   eiOffsetY = 30;           // �������� ������ �� ���������
extern int   eiStepY   = 12;           // ��� �������� ������ �� ���������
extern int   eiX1Row   = 3;            // ���������� X ������ �������
extern int   eiX2Row   = 165;          // ���������� X ������ �������
extern int   eiX3Row   = 230;          // ���������� X ������ �������
extern int   eiX4Row   = 305;          // ���������� X �������� �������
extern color ecText    = Gray;         // ���� ������
extern color ecProfit  = Green;        // ���� �������
extern color ecLoss    = FireBrick;    // ���� ������

extern string note1 = "����� - ��� �������, ����� �������� ������";
extern string esSymbol = "";
extern string note2 = "-1 - ��� ���������� ������, ����� �������� ���������� �����";
extern int eiMagic = -1;

//------- ���������� ���������� ���������� ------------------------------------+

//------- ������ ���������� ---------------------------------------------------+

//------- ���������� ������� ������� ------------------------------------------+

//+----------------------------------------------------------------------------+
//|  Custom indicator initialization function                                  |
//+----------------------------------------------------------------------------+
void init() {
  DeleteObjects();
  Comment("");
}

//+----------------------------------------------------------------------------+
//|  Custom indicator deinitialization function                                |
//+----------------------------------------------------------------------------+
void deinit() {
  DeleteObjects();
  Comment("");
}

//+----------------------------------------------------------------------------+
//|  Custom indicator iteration function                                       |
//+----------------------------------------------------------------------------+
void start() {
  datetime d0, d1, d2, d3, d4, d5, d6, d7, d8;

  d0=StrToTime(TimeToStr(TimeCurrent(), TIME_DATE));
  while (TimeDayOfWeek(d0)<1 || TimeDayOfWeek(d0)>5) d0-=24*60*60;
  d1=d0-24*60*60;
  while (TimeDayOfWeek(d1)<1 || TimeDayOfWeek(d1)>5) d1-=24*60*60;
  d2=d1-24*60*60;
  while (TimeDayOfWeek(d2)<1 || TimeDayOfWeek(d2)>5) d2-=24*60*60;
  d3=d2-24*60*60;
  while (TimeDayOfWeek(d3)<1 || TimeDayOfWeek(d3)>5) d3-=24*60*60;
  d4=d3-24*60*60;
  while (TimeDayOfWeek(d4)<1 || TimeDayOfWeek(d4)>5) d4-=24*60*60;
  d5=DateOfMonday();
  d6=StrToTime(Year()+"."+Month()+".01");
  d7=DateBeginQuarter();
  d8=StrToTime(Year()+".01.01");

  double tu=GetProfitOpenPosInPoint();
  double u0=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d0);
  double u1=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d1)-u0;
  double u2=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d2)-u1-u0;
  double u3=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d3)-u2-u1-u0;
  double u4=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d4)-u3-u2-u1-u0;
  double u5=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d5);
  double u6=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d6);
  double u7=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d7);
  double u8=GetProfitFromDateInPoint(esSymbol, -1, eiMagic, d8);

  double tb=AccountBalance(), tp=AccountProfit();
  double p0=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d0);
  double p1=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d1)-p0;
  double p2=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d2)-p1-p0;
  double p3=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d3)-p2-p1-p0;
  double p4=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d4)-p3-p2-p1-p0;
  double p5=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d5);
  double p6=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d6);
  double p7=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d7);
  double p8=GetProfitFromDateInCurrency(esSymbol, -1, eiMagic, d8);

  string st;
  switch (eiPercent) {
    case 0 :         st="��������"          ; break;
    case 1 : tb-=p0; st="�� ������ ���"     ; break;
    case 2 : tb-=p5; st="�� ������ ������"  ; break;
    case 3 : tb-=p6; st="�� ������ ������"  ; break;
    case 4 : tb-=p7; st="�� ������ ��������"; break;
    default: tb-=p8; st="�� ������ ����"    ; break;
  }
  double tr=tp*100/tb;
  double r0=p0*100/tb;
  double r1=p1*100/tb;
  double r2=p2*100/tb;
  double r3=p3*100/tb;
  double r4=p4*100/tb;
  double r5=p5*100/tb;
  double r6=p6*100/tb;
  double r7=p7*100/tb;
  double r8=p8*100/tb;

  SetLabel("iProfit05", "�������", ecText, eiX1Row+25, eiOffsetY);
  SetLabel("iProfit06", "� �������", ecText, eiX2Row-15, eiOffsetY);
  SetLabel("iProfit07", "� ������", ecText, eiX3Row+35, eiOffsetY);

  SetLabel("iProfit11", "������� �������", ecText, eiX1Row, eiOffsetY+1*eiStepY);
  SetLabel("iProfit21", "������� �� �������", ecText, eiX1Row, eiOffsetY+2*eiStepY);
  SetLabel("iProfit31", "������� �� "+TimeToStr(d1, TIME_DATE), ecText, eiX1Row, eiOffsetY+3*eiStepY);
  SetLabel("iProfit41", "������� �� "+TimeToStr(d2, TIME_DATE), ecText, eiX1Row, eiOffsetY+4*eiStepY);
  SetLabel("iProfit51", "������� �� "+TimeToStr(d3, TIME_DATE), ecText, eiX1Row, eiOffsetY+5*eiStepY);
  SetLabel("iProfit61", "������� �� "+TimeToStr(d4, TIME_DATE), ecText, eiX1Row, eiOffsetY+6*eiStepY);
  SetLabel("iProfit71", "������� �� ������", ecText, eiX1Row, eiOffsetY+7*eiStepY);
  SetLabel("iProfit81", "������� �� �����", ecText, eiX1Row, eiOffsetY+8*eiStepY);
  SetLabel("iProfit91", "������� �� �������", ecText, eiX1Row, eiOffsetY+9*eiStepY);
  SetLabel("iProfit01", "������� �� ���", ecText, eiX1Row, eiOffsetY+10*eiStepY);

  SetLabel("iProfit12", DoubleToStr(tu, 0), ColorOnSign(tp), eiX2Row, eiOffsetY+1*eiStepY);
  SetLabel("iProfit22", DoubleToStr(u0, 0), ColorOnSign(u0), eiX2Row, eiOffsetY+2*eiStepY);
  SetLabel("iProfit32", DoubleToStr(u1, 0), ColorOnSign(u1), eiX2Row, eiOffsetY+3*eiStepY);
  SetLabel("iProfit42", DoubleToStr(u2, 0), ColorOnSign(u2), eiX2Row, eiOffsetY+4*eiStepY);
  SetLabel("iProfit52", DoubleToStr(u3, 0), ColorOnSign(u3), eiX2Row, eiOffsetY+5*eiStepY);
  SetLabel("iProfit62", DoubleToStr(u4, 0), ColorOnSign(u4), eiX2Row, eiOffsetY+6*eiStepY);
  SetLabel("iProfit72", DoubleToStr(u5, 0), ColorOnSign(u5), eiX2Row, eiOffsetY+7*eiStepY);
  SetLabel("iProfit82", DoubleToStr(u6, 0), ColorOnSign(u6), eiX2Row, eiOffsetY+8*eiStepY);
  SetLabel("iProfit92", DoubleToStr(u7, 0), ColorOnSign(u7), eiX2Row, eiOffsetY+9*eiStepY);
  SetLabel("iProfit02", DoubleToStr(u8, 0), ColorOnSign(u8), eiX2Row, eiOffsetY+10*eiStepY);

  SetLabel("iProfit13", DoubleToStr(tp, 2), ColorOnSign(tp), eiX3Row, eiOffsetY+1*eiStepY);
  SetLabel("iProfit23", DoubleToStr(p0, 2), ColorOnSign(p0), eiX3Row, eiOffsetY+2*eiStepY);
  SetLabel("iProfit33", DoubleToStr(p1, 2), ColorOnSign(p1), eiX3Row, eiOffsetY+3*eiStepY);
  SetLabel("iProfit43", DoubleToStr(p2, 2), ColorOnSign(p2), eiX3Row, eiOffsetY+4*eiStepY);
  SetLabel("iProfit53", DoubleToStr(p3, 2), ColorOnSign(p3), eiX3Row, eiOffsetY+5*eiStepY);
  SetLabel("iProfit63", DoubleToStr(p4, 2), ColorOnSign(p4), eiX3Row, eiOffsetY+6*eiStepY);
  SetLabel("iProfit73", DoubleToStr(p5, 2), ColorOnSign(p5), eiX3Row, eiOffsetY+7*eiStepY);
  SetLabel("iProfit83", DoubleToStr(p6, 2), ColorOnSign(p6), eiX3Row, eiOffsetY+8*eiStepY);
  SetLabel("iProfit93", DoubleToStr(p7, 2), ColorOnSign(p7), eiX3Row, eiOffsetY+9*eiStepY);
  SetLabel("iProfit03", DoubleToStr(p8, 2), ColorOnSign(p8), eiX3Row, eiOffsetY+10*eiStepY);

  SetLabel("iProfit14", DoubleToStr(tr, 2)+" %", ColorOnSign(tr), eiX4Row, eiOffsetY+1*eiStepY);
  SetLabel("iProfit24", DoubleToStr(r0, 2)+" %", ColorOnSign(r0), eiX4Row, eiOffsetY+2*eiStepY);
  SetLabel("iProfit34", DoubleToStr(r1, 2)+" %", ColorOnSign(r1), eiX4Row, eiOffsetY+3*eiStepY);
  SetLabel("iProfit44", DoubleToStr(r2, 2)+" %", ColorOnSign(r2), eiX4Row, eiOffsetY+4*eiStepY);
  SetLabel("iProfit54", DoubleToStr(r3, 2)+" %", ColorOnSign(r3), eiX4Row, eiOffsetY+5*eiStepY);
  SetLabel("iProfit64", DoubleToStr(r4, 2)+" %", ColorOnSign(r4), eiX4Row, eiOffsetY+6*eiStepY);
  SetLabel("iProfit74", DoubleToStr(r5, 2)+" %", ColorOnSign(r5), eiX4Row, eiOffsetY+7*eiStepY);
  SetLabel("iProfit84", DoubleToStr(r6, 2)+" %", ColorOnSign(r6), eiX4Row, eiOffsetY+8*eiStepY);
  SetLabel("iProfit94", DoubleToStr(r7, 2)+" %", ColorOnSign(r7), eiX4Row, eiOffsetY+9*eiStepY);
  SetLabel("iProfit04", DoubleToStr(r8, 2)+" %", ColorOnSign(r8), eiX4Row, eiOffsetY+10*eiStepY);

  Comment("������� ������� ������������ ������� "+st);
}

//+----------------------------------------------------------------------------+
//|  ���������� ���� �� ����� �����                                            |
//+----------------------------------------------------------------------------+
color ColorOnSign(double nu) {
  color lcColor=ecText;

  if (nu>0) lcColor=ecProfit;
  if (nu<0) lcColor=ecLoss;

  return(lcColor);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 12.05.2008                                                     |
//|  �������� : ���������� ���� ������ ��������                                |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|                                    (-2 - �����������)                      |
//|                                    (-1 - �������)                          |
//|    no - ����� ��������             ( 0 - �������)                          |
//|                                    ( 1 - ���������)                        |
//|                                    ( 2 - �����������)                      |
//+----------------------------------------------------------------------------+
datetime DateBeginQuarter(int nk=0) {
  int ye=Year()-MathFloor(nk/4);
  nk=MathMod(nk, 4);
  int mo=Month()-MathMod(Month()+2, 3)+3*nk;
  if (mo<1) {
    mo+=12;
    ye--;
  }
  if (mo>12) {
    mo-=12;
    ye++;
  }

  return(StrToTime(ye+"."+mo+".01"));
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 12.05.2008                                                     |
//|  �������� : ���������� ���� ������������                                   |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|                                    (-2 - ������� ������)                   |
//|                                    (-1 - ������� ������)                   |
//|    no - ����� ������������         ( 0 - ������� ������)                   |
//|                                    ( 1 - ���������, ��������� �������)     |
//|                                    ( 2 - �����������)                      |
//+----------------------------------------------------------------------------+
datetime DateOfMonday(int no=0) {
  datetime dt=StrToTime(TimeToStr(TimeCurrent(), TIME_DATE));

  while (TimeDayOfWeek(dt)!=1) dt-=24*60*60;
  dt+=no*7*24*60*60;

  return(dt);
}

//+----------------------------------------------------------------------------+
//|  �������� ��������.                                                        |
//+----------------------------------------------------------------------------+
void DeleteObjects() {
  string st="iProfit";
  int    i, j;

  for (i=0; i<10; i++) {
    for (j=1; j<8; j++) ObjectDelete(st+i+j);
  }
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 19.02.2008                                                     |
//|  �������� : ���������� ��������� ������ � ������ ��������                  |
//|             �������� � ����������� ���� �������                           |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������             (""   - ����� ������,         |
//|                                               NULL - ������� ������)       |
//|    op - ��������                             (-1   - ����� �������)        |
//|    mn - MagicNumber                          (-1   - ����� �����)          |
//|    dt - ���� � ����� � �������� � 1970 ����  ( 0   - � ������ �������)     |
//+----------------------------------------------------------------------------+
double GetProfitFromDateInCurrency(string sy="", int op=-1, int mn=-1, datetime dt=0)
{
  double p=0;
  int    i, k=OrdersHistoryTotal();

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (dt<OrderCloseTime()) {
              p+=OrderProfit()+OrderCommission()+OrderSwap();
            }
          }
        }
      }
    }
  }
  return(p);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 04.02.2009                                                     |
//|  �������� : ���������� ��������� ������ � �������                          |
//|             �������� � ����������� ���� �������                           |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������             (""   - ����� ������,         |
//|                                               NULL - ������� ������)       |
//|    op - ��������                             (-1   - ����� �������)        |
//|    mn - MagicNumber                          (-1   - ����� �����)          |
//|    dt - ���� � ����� � �������� � 1970 ����  ( 0   - � ������ �������)     |
//+----------------------------------------------------------------------------+
double GetProfitFromDateInPoint(string sy="", int op=-1, int mn=-1, datetime dt=0)
{
  double p=0, po;
  int    i, k=OrdersHistoryTotal();

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (dt<OrderCloseTime()) {
              po=MarketInfo(OrderSymbol(), MODE_POINT);
              if (po==0) if (StringFind(sy, "JPY")<0) po=0.0001; else po=0.01;
              if (OrderType()==OP_BUY) {
                p+=(OrderClosePrice()-OrderOpenPrice())/po;
              }
              if (OrderType()==OP_SELL) {
                p+=(OrderOpenPrice()-OrderClosePrice())/po;
              }
            }
          }
        }
      }
    }
  }
  return(p);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 01.08.2008                                                     |
//|  �������� : ���������� ��������� ������ �������� ������� � �������         |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������   (""   - ����� ������,                   |
//|                                     NULL - ������� ������)                 |
//|    op - ��������                   (-1   - ����� �������)                  |
//|    mn - MagicNumber                (-1   - ����� �����)                    |
//+----------------------------------------------------------------------------+
int GetProfitOpenPosInPoint(string sy="", int op=-1, int mn=-1) {
  double p;
  int    i, k=OrdersTotal(), pr=0;

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (mn<0 || OrderMagicNumber()==mn) {
          p=MarketInfo(OrderSymbol(), MODE_POINT);
          if (p==0) if (StringFind(OrderSymbol(), "JPY")<0) p=0.0001; else p=0.01;
          if (OrderType()==OP_BUY) {
            pr+=(MarketInfo(OrderSymbol(), MODE_BID)-OrderOpenPrice())/p;
          }
          if (OrderType()==OP_SELL) {
            pr+=(OrderOpenPrice()-MarketInfo(OrderSymbol(), MODE_ASK))/p;
          }
        }
      }
    }
  }
  return(pr);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 12.10.2007                                                     |
//|  �������� : ��������� ��������� �����                                      |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    nm - ������������ �������                                               |
//|    tx - �����                                                              |
//|    cl - ���� �����                                                         |
//|    xd - ���������� X � ��������                                            |
//|    yd - ���������� Y � ��������                                            |
//|    cr - ����� ���� ��������        (0 - ����� �������)                     |
//|    fs - ������ ������              (8 - �� ���������)                      |
//+----------------------------------------------------------------------------+
void SetLabel(string nm, string tx, color cl, int xd, int yd, int cr=0, int fs=9) {
  if (ObjectFind(nm)<0) ObjectCreate(nm, OBJ_LABEL, 0, 0,0);
  ObjectSetText(nm, tx, fs);
  ObjectSet(nm, OBJPROP_COLOR    , cl);
  ObjectSet(nm, OBJPROP_XDISTANCE, xd);
  ObjectSet(nm, OBJPROP_YDISTANCE, yd);
  ObjectSet(nm, OBJPROP_CORNER   , cr);
  ObjectSet(nm, OBJPROP_FONTSIZE , fs);
}
//+----------------------------------------------------------------------------+

