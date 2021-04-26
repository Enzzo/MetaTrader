//+------------------------------------------------------------------+
//|                                               Mindhero_robot.mq4 |
//|                                     Copyright � 2010, ENSED Team |
//|                                             http://www.ensed.org |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2010, ENSED Team"
#property link      "http://www.ensed.org"

extern int    SL            = 150, //�������� Stop Loss (� �������)
              TP            = 150; //�������� Take Profit (� �������)
extern double Lots          = 0.1; //������� ���
extern string Order_Comment = "Mindhero_robot"; //�����������, ������� ���������� ������
extern int    Slipage       = 5; //������� ����������� ����������� ��������������� (� �������)
extern int    Magic_Number  = 876376; //���������� ����� - ����� ������� ��� ������ (������ ������� "����" ������)
extern bool   Play_Sound    = true; //��������������� ����� ��� ��������: true - ���������, false - ���������

//------------
extern int TF_1  = 15; //15 �����
extern int TF_2  = 240; //240 ����� (4 ����)

extern int period_1 = 10;
extern int fiboLevel_1 = 1;
extern bool alertMode_1 = false;
extern string Prefix_1       = "AK";
extern bool   ReverseSignal_1 = False;

extern int period_2 = 10;
extern int fiboLevel_2 = 1;
extern bool alertMode_2 = false;
extern string Prefix_2       = "AK";
extern bool   ReverseSignal_2 = False;


//------------

//+----------------------------------------------------------------------+
//+                           ��������-����                              +
extern bool UseTrailing  = true; //���������/���������� T-SL
extern int  TrailingStop = 50;   // ������������� ������ �����
extern int  TrailingStep = 1;    // ��� �����
//+                           ��������-����                              +
//+----------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                          �������. ������� ����������� ��� ������������� ���������                                 |
void init() {
  if(GlobalVariableCheck("this_bar"+Symbol()+Period()))
    GlobalVariableDel("this_bar"+Symbol()+Period());
  return;
}
//|                          �������. ������� ����������� ��� ������������� ���������                                 |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                         �������. ������� ����������� ��� ��������������� ���������                                |
void deinit() {
  if(GlobalVariableCheck("this_bar"+Symbol()+Period()))
    GlobalVariableDel("this_bar"+Symbol()+Period());   
  return;
}
//|                         �������. ������� ����������� ��� ��������������� ���������                                |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                         ������� ������ ��������� �������                                          |
int fsignals() {
  if(
      ((iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,0)<iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,0)) 
        && (iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,1)>iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,1)))
       &&
      ((iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,0)<iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,0)) 
        && (iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,1)>iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,1)))   
    ) 
    return(0); //������ �� �������� �������

  if(
      ((iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,0)>iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,0)) 
        && (iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,1)<iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,1)))
       &&
      ((iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,0)>iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,0)) 
        && (iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,1)<iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,1)))   
    ) 
    return(1); //������ �� �������� �������
  return(-1); //���������� �������
} //end int fsignals()
//|                                         ������� ������ ��������� �������                                          |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                            ������� ������������ ����� ��������� ������ �� ������ ����                             |
bool this_bar() {
  if(
      (!GlobalVariableCheck("this_bar"+Symbol()+Period()))
      || (GlobalVariableGet("this_bar"+Symbol()+Period())!=Time[0])
    ) {
    GlobalVariableSet("this_bar"+Symbol()+Period(),Time[0]);
    return(false);
  } else {
    return(true);
  } //end if (.. (!GlobalVariableCheck("this_bar"+Symbol()+Period()))
} //end bool this_bar()
//|                            ������� ������������ ����� ��������� ������ �� ������ ����                             |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                        ������� ������ ������� ������� ����                                        |
bool find_orders(int magic=-1, int type=-1, string symb="NULL") {
  /* ���������� ������, ���� ������ ���� �� ���� ����� ������� ���� � ������ ���������� ������� �� ������� ������� */
  for (int i=OrdersTotal()-1; i>=0; i--) {
    if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
    if(((OrderType()==type) || (type==-1))
       && ((OrderMagicNumber()==magic) || (magic==-1))
       && ((OrderSymbol()==Symbol() || (symb=="NONE")))) {
      //���� ����� ������, �� ���������� true � ������� �� �����
      return(true);
      break;
    } //end if((OrderType()==type) && (OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()))
  } //end for (int i2=OrdersTotal()-1; i2>=0; i2--)

  return(false); //���������� false
} //end bool find_orders(int magic, int type)
//|                                        ������� ������ ������� ������� ����                                        |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                  ������� ������� �������� Stop Loss ��� �������                                   |
double sl(int sl_value, int type, double price=0.0, string symb="NONE", int rmode=1) {
  //type=0 -> �������� �������
  //type=1 -> �������� �������
  if(symb=="NONE") symb=Symbol();
  if(type==0) price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS));
  if(type==1) price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS));
  if(sl_value<=0) return(0);
  if(rmode==1) {
    if((type==0) || (type==2) || (type==4))     return(MarketInfo(symb,MODE_ASK)-sl_value*MarketInfo(symb,MODE_POINT)); //��� �������
    if((type==1) || (type==3) || (type==5))     return(MarketInfo(symb,MODE_BID)+sl_value*MarketInfo(symb,MODE_POINT)); //��� ������
  }
  if(rmode==2) {
    if((type==0) || (type==2) || (type==4))     return(MarketInfo(symb,MODE_BID)-sl_value*MarketInfo(symb,MODE_POINT)); //��� �������
    if((type==1) || (type==3) || (type==5))     return(MarketInfo(symb,MODE_ASK)+sl_value*MarketInfo(symb,MODE_POINT)); //��� ������
  }
} //end double sl(int sl_value, int type, double price=0.0, string symb="NONE", int rmode=1)
//|                                  ������� ������� �������� Stop Loss ��� �������                                   |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                 ������� ������� �������� Take Profit ��� �������                                  |
double tp(int tp_value, int type, double price=0.0, string symb="NONE") {
  //type=0 -> �������� �������
  //type=1 -> �������� �������
  if(symb=="NONE") symb=Symbol();
  if(type==0) price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS));
  if(type==1) price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS));
  if(tp_value<=0) return(0);
  if((type==0) || (type==2) || (type==4))     return(price+tp_value*MarketInfo(symb,MODE_POINT)); //��� �������
  if((type==1) || (type==3) || (type==5))     return(MarketInfo(symb,MODE_BID)-tp_value*MarketInfo(symb,MODE_POINT)); //��� ������
} //end double tp(int tp_value, int type, double price=0.0, string symb="NONE")
//|                                 ������� ������� �������� Take Profit ��� �������                                  |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                              ������� �������� �������                                             |
void open_positions(int signal, double lot, double price=0.0, string symb="NONE") {
  //signal=0 -> ������ �� �������� �������
  //signal=1 -> ������ �� �������� �������
  /* extern */ int Count_Of_Trade_Try=5, Pause_Of_Trade_Try=5;

  int    i   = 0; //���������� ��� �������� �����
  int    err = 0;

  if(symb=="NONE") symb=Symbol();
  if(signal==0)
    price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS)); //���� �������� ��� �������
  if(signal==1)
    price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS)); //���� �������� ��� ������

  while(i<=Count_Of_Trade_Try) {
    //���� ������ �������� ������ (����������). ��� �������� ���������� ��������� ��������� �� ������ ������:
    int ticket = OrderSend(Symbol(),      //������
                           signal,        //��� ������
                           lot,           //�����
                           price,         //���� ��������
                           Slipage,       //������� ����������� �������
                           sl(SL,signal), //�������� Stop Loss
                           tp(TP,signal), //�������� Take Profit
                           Order_Comment, //����������� ������
                           Magic_Number,  //���������� �����
                           0,             //���� ��������� (������������ ��� ���������� �������)
                           CLR_NONE);     //���� ������������ ������� �� ������� (CLR_NONE - ������� �� ��������)
    if(ticket!=-1) //���� �������� ��������� �������, ������� ����������� ������ � ������� �� �����
      break;
    err=GetLastError(); 
    if(err!=0) Print("������: "+Market_Err_To_Str(err));
    i++;
    Sleep(Pause_Of_Trade_Try*1000); //� ������ ������ ������ ����� ����� ����� ��������
  } //end while(i<=count)
} //end void open_positions(int signal, double lot, double price=0.0, string symb="NONE")
//|                                              ������� �������� �������                                             |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------+
//|                                      ������� ����������� ����� ������                                 |
string Market_Err_To_Str(int err) {
/* ������� ���������� ������ ���� ������ �������� �������� */
  switch(err) {
    case(0):   return("��� ������");
    case(1):   return("��� ������, �� ��������� ����������");
    case(2):   return("����� ������");
    case(3):   return("������������ ���������");
    case(4):   return("�������� ������ �����");
    case(5):   return("������ ������ ����������� ���������");
    case(6):   return("��� ����� � �������� ��������");
    case(7):   return("������������ ����");
    case(8):   return("������� ������ �������");
    case(9):   return("������������ �������� ���������� ���������������� �������");
    case(64):  return("���� ������������");
    case(65):  return("������������ ����� �����");
    case(128): return("����� ���� �������� ���������� ������");
    case(129): return("������������ ����");
    case(130): return("������������ �����");
    case(131): return("������������ �����");
    case(132): return("����� ������");
    case(133): return("�������� ���������");
    case(134): return("������������ ����� ��� ���������� ��������");
    case(135): return("���� ����������");
    case(136): return("��� ���");
    case(137): return("������ �����");
    case(138): return("����� ����");
    case(139): return("����� ������������ � ��� ��������������");
    case(140): return("��������� ������ �������");
    case(141): return("������� ����� ��������");
    case(145): return("����������� ���������, �.�. ����� ������� ������ � �����");
    case(146): return("���������� �������� ������");
    case(147): return("������������� ���� ��������� ��������� ��������");
    case(148): return("���������� �������� � ���������� ������� �������� �������, �������������� ��������");
    case(149): return("������� ������� ��������������� ������� � ��� ������������ � ������, ���� ������������ ���������");
    case(150): return("������� ������� ������� �� ����������� � ������������ � �������� FIFO");
   
    default:   return("");
  } //end switch(err)
} //end string Err_To_Str(int err)
//|                                      ������� ����������� ����� ������                                 |
//+-------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------+
//|                                         �������� �������� ������                                      |
//+----------------------------------------------------------------------------------------------------+
//|                           ������� �������� ������ �� � ������ (������)                            |


bool close_by_ticket(int c_ticket, int slipage) {
  /*
     ������� �������� ������ �� � ������ (������).
     ��� �������� ��������� ������ ����������� ������� ����������� ����������� ��������������� (slipage)
  */
/* extern */ int Count_Of_Trade_Try=5, Pause_Of_Trade_Try=5;

int    i       = 0;     //���������� ��� �������� �����
int    err     = 0;
bool   ticket  = false; //��������� ��� ����������� (��)���������� ����� �������� ������
double price   = 0.0; //���� ��� ����������� ������ (��� �������� �������)
  if(OrderSelect(c_ticket,SELECT_BY_TICKET,MODE_TRADES)) { //�������� ����� �� ������
    if(OrderType()==OP_BUY)  price = NormalizeDouble(Bid,Digits); //���� ��� �������
    if(OrderType()==OP_SELL) price = NormalizeDouble(Ask,Digits); //���� ��� ������
    for(i=0;i<=Count_Of_Trade_Try;i++) {
      if(OrderType()<=1) //���� �������� ����� - ��������� ���, ���� ���������� - �������
        ticket=OrderClose(OrderTicket(),OrderLots(),price,slipage,CLR_NONE);
      else
        ticket=OrderDelete(OrderTicket());

      if(ticket) { //���� �������� ��� �������� ������ ������� - ���������� true � ������� �� �����
        return(true);
        break;
      } //end if(ticket)
      err=GetLastError();
      if(err!=0) Print("������: "+Market_Err_To_Str(err));
      Sleep(Pause_Of_Trade_Try*1000); //� ������ ������ ������ ����� ����� ����� ��������
    } //end for(i=0;i<=Count_Of_Trade_Try;i++)
  } //end if(OrderSelect(c_ticket,SELECT_BY_TICKET,MODE_TRADES))

  return(false); //���������� false
} //end bool close_by_ticket(int c_ticket)
//|                           ������� �������� ������ �� � ������ (������)                            |
//+----------------------------------------------------------------------------------------------------+

bool cbm(int magic, int slipage, int type) {
  /*
    close by magic (�������� ���� ������� ������� ���� � ������ MagicNumber)
    ����������� ����������� ���������� ��������������� (slipage)
    ������������ ������� close_by_ticket.
  */
  int n = 0;
  while (find_orders(magic, type))
    for (int i2=OrdersTotal()-1; i2>=0; i2--) {
      if (!OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)) break;

      if ((OrderType()==type) && (OrderMagicNumber()==magic)) {
        close_by_ticket(OrderTicket(), slipage);
        n++;
      } //end if (((OrderType()==OP_BUY) || (OrderType()==OP_SELL)) && (OrderMagicNumber()==magic))
    } //end for (int i2=OrdersTotal()-1; i2>=0; i2--)

  if(n>0)   
    return(true);

  return(false);
} //end bool cbm(int magic, int slipage, int type)
//|                                         �������� �������� ������                                      |
//+-------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                                 �������� ���� ����                                                |
void T_SL() {
  if(!UseTrailing) return;
  int i = 0;
  for(i=0; i<OrdersTotal(); i++) {
    if(!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))) continue;
    if(OrderSymbol() != Symbol() || OrderMagicNumber()!=Magic_Number) continue;       

    if(OrderType()==OP_BUY) {
      if(NormalizeDouble(Bid-OrderOpenPrice(),Digits)>NormalizeDouble(TrailingStop*Point,Digits)) {
        if(NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-(TrailingStop+TrailingStep-1)*Point,Digits))
          OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid-TrailingStop*Point,Digits), OrderTakeProfit(), 0, CLR_NONE);
      } //end if(NormalizeDouble(Bid-OrderOpenPrice(),Digits)>NormalizeDouble(TrailingStop*Point,Digits))
    } //end if(OrderType()==OP_BUY)

    if(OrderType()==OP_SELL) {
      if(NormalizeDouble(OrderOpenPrice()-Ask,Digits)>NormalizeDouble(TrailingStop*Point,Digits)) {
        if(NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(Ask+(TrailingStop+TrailingStep-1)*Point,Digits))
          OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask+TrailingStop*Point,Digits), OrderTakeProfit(), 0, CLR_NONE);
      } //end if(NormalizeDouble(OrderOpenPrice()-Ask,Digits)>NormalizeDouble(TrailingStop*Point,Digits))
    } //end if(OrderType()==OP_SELL)
  } //end for(i=0; i<OrdersTotal(); i++)
} //end void T_SL()
//|                                                 �������� ���� ����                                                |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                                   ������� �������                                                 |
void start() {

  int sig = fsignals();

  if(!find_orders(Magic_Number)) {
    if((sig!=-1)) {
      if(!this_bar()) {
        open_positions(sig, Lots);
        if(Play_Sound)
          PlaySound("alert.wav");
      }
    } //end if((sig!=-1) && (!this_bar()))
  } else {
    if(sig==0) {
      if(cbm(Magic_Number, Slipage, 1)) {
        open_positions(sig, Lots);
        if(Play_Sound)
          PlaySound("alert.wav");
      } //end if(cbm(Magic_Number, Slipage, 1))
    } //end if(sig==0)
    if(sig==1) {
      if(cbm(Magic_Number, Slipage, 0)) {
        open_positions(sig, Lots);
        if(Play_Sound)
          PlaySound("alert.wav");
      } //end if(cbm(Magic_Number, Slipage, 0))
    } //end if(sig==1)
    T_SL();
  } //end if(!find_orders(Magic_Number)) (else)
  return;
}
//|                                                   ������� �������                                                 |
//+-------------------------------------------------------------------------------------------------------------------+