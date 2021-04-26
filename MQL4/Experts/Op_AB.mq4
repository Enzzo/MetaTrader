//+------------------------------------------------------------------+
//|                                                        Op_AB.mq4 |
//|                                     Copyright � 2010, ENSED Team |
//|                                             http://www.ensed.org |
//+------------------------------------------------------------------+

#property copyright "Copyright � 2010, ENSED Team"
#property link      "http://www.ensed.org"

extern string _ = "______________ BLOCK A _________________";
extern bool   ON_A             = true; //���������/���������� ����� A
extern int    OP_Hour_A        = 12; //��� ��������
extern int    OP_Minute_A      = 00; //������ ��������
extern int    MinToFindHL_A    = 240; //���������� �����, �� ������� ���� ������������ � ����������� ���� ��� ����� �
extern int    MagicNumber_A    = 65651; /* ���������� ����� ��� ������� ����� A, ����������� �����, �� ������� ����� ����� 
                                          ��������� ������ ������� ������ � �����, � ����� A � ����������� */
extern int    Profit_to_SL_A    = 400; //�������� �������, ����� ������� ������ ���� � ��������� (���� A)
extern int    SL_Profit_Level_A = 1;  //�������� ��������� (���� A), �� ��������� +1
extern int    Close_Hour_A      = 23; //��� ��������������� ��������/�������� ������ ����� A                                     
extern int    Close_Minute_A    = 00; //������ ��������������� ��������/�������� ������ ����� A                                     
extern string __ = "____ buy stop ___";
extern int    N_BUYSTOP_A      = 500; //���������� ������� ���������, �� ������� ��������� BUY STOP ����� �
extern double BUYSTOP_Lots_A   = 0.1; //������� ��� ������� BUY STOP ����� �
extern int    BUYSTOP_TP_A     = 1000; //������� TP ��� ������ BUY STOP ����� A
extern int    BUYSTOP_SL_A     = 1000; /* ������� SL ��� ������ BUY STOP ����� A (� ������, ���� ������ ��������� �� ���� SL 
                                         ������ SELL STOP ��� ���� ���������� ����� ������ �������� ���� ������� ������ ��������
                                         BUYSTOP_SL_A) */

extern string ___ = "____ sell stop ___";
extern int    N_SELLSTOP_A     = 500; //���������� ������� ���������, �� ������� ��������� SELL STOP ����� �
extern double SELLSTOP_Lots_A  = 0.1; //������� ��� ������� SELL STOP ����� �
extern int    SELLSTOP_TP_A    = 1000; //������� TP ��� ������ SELL STOP ����� A
extern int    SELLSTOP_SL_A    = 1000; /* ������� SL ��� ������ SELL STOP ����� A (� ������, ���� ������ ��������� �� ���� SL 
                                         ������ BUY STOP ��� ���� ���������� ����� ������ �������� ���� ������� ������ ��������
                                         SELLSTOP_SL_A) */
extern string ____ = "______________ BLOCK B _________________";
extern bool   ON_B             = true; //���������/���������� ����� B
extern int    OP_Hour_B        = 12; //��� ��������
extern int    OP_Minute_B      = 00; //������ ��������
extern int    MinToFindHL_B    = 240; //���������� �����, �� ������� ���� ������������ � ����������� ���� ��� ����� B
extern int    MagicNumber_B    = 65652; /* ���������� ����� ��� ������� ����� B, ����������� �����, �� ������� ����� ����� 
                                          ��������� ������ ������� ������ � �����, � ����� B � ����������� */
extern int    Profit_to_SL_B    = 400; //�������� �������, ����� ������� ������ ���� � ��������� (���� B)
extern int    SL_Profit_Level_B = 1;  //�������� ��������� (���� B), �� ��������� +1
extern int    Close_Hour_B      = 23; //��� ��������������� ��������/�������� ������ ����� B                                     
extern int    Close_Minute_B    = 00; //������ ��������������� ��������/�������� ������ ����� B                                     
extern string _____ = "____ buy stop ___";
extern int    N_BUYSTOP_B      = 500; //���������� ������� ���������, �� ������� ��������� BUY STOP ����� B
extern double BUYSTOP_Lots_B   = 0.1; //������� ��� ������� BUY STOP ����� B
extern int    BUYSTOP_TP_B     = 1000; //������� TP ��� ������ BUY STOP ����� B
extern int    BUYSTOP_SL_B     = 1000; /* ������� SL ��� ������ BUY STOP ����� B (� ������, ���� ������ ��������� �� ���� SL 
                                         ������ SELL STOP ��� ���� ���������� ����� ������ �������� ���� ������� ������ ��������
                                         BUYSTOP_SL_B) */

extern string ______ = "____ sell stop ___";
extern int    N_SELLSTOP_B     = 500; //���������� ������� ���������, �� ������� ��������� SELL STOP ����� B
extern double SELLSTOP_Lots_B  = 0.1; //������� ��� ������� SELL STOP ����� B
extern int    SELLSTOP_TP_B    = 1000; //������� TP ��� ������ SELL STOP ����� B
extern int    SELLSTOP_SL_B    = 1000; /* ������� SL ��� ������ SELL STOP ����� B (� ������, ���� ������ ��������� �� ���� SL 
                                         ������ BUY STOP ��� ���� ���������� ����� ������ �������� ���� ������� ������ ��������
                                         SELLSTOP_SL_B) */
extern string _______ = "___________";
extern int    Slipage          = 50; //������� ����������� ��������������� 
extern bool   Send_Acc_Info    = true;
extern int    Minute_To_Send    = 02;
extern string Tel_Num_1 = "+79627273648";
extern string Tel_Num_2 = "";
#import "SkypeLib.dll"
   bool SendSkypeSMS(int &ExCode[], string Num,string Message);
   bool SendSkypeMessage(int &ExCode[], string User, string Message);
#import


bool IsSend=false;

//+-------------------------------------------------------------------------------------------------------------------+
//|                                           ������� ������������� ���������                                         |
int init() {
//----
   
//----
  return(0);
} //end int init()
//|                                           ������� ������������� ���������                                         |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                               ������� ������� ���������                                           |
int start() {
//----
  string view="";
  while (((IsExpertEnabled()) && (!IsStopped())) || (IsTesting())) {
    /* (���� �������� ��������� � ����� ������������� �� ����������) ��� (�������� � ������ �����) - ��������� ���� �����
       ���� ����������� ��� ����, ����� ��� � 0.5 ������ ��������� ����������� ���, ��� ������� ����� ����� �� ��������� ������ �����
       ��������� ("��� (�������� � ������ �����)") ������� ��� ����, ����� � ������� _���_ � ��� ����������� ���� ����� (��. �����) */

    
    
    if(ON_A) BLOCK_A(); 
    if(ON_B) BLOCK_B(); 

    if(IsTesting())
      break; /* ������� ������������� �� �����, ���� �������� � ������ ������������. ��� ���� ����� ����������� ����� ���� ��� �� 
                ������ ����, �.�. ��������� �������� ���������� ������ ������ (�.�. ����������� ��������� �� �������� � �������) */

    if(Send_Acc_Info) {
      if(Minute()==Minute_To_Send && !IsSend) {
        //�������� �� SMS ���������� �� ����� � �������� �������
        int ExCode[1];

        Print("���������� SMS ���������... "+Tel_Num_1);
        Print(SendSkypeSMS(ExCode, Tel_Num_1, str_acc_info()));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
          
        Print("���������� SMS ���������... "+Tel_Num_2);
        Print(SendSkypeSMS(ExCode, Tel_Num_2, str_acc_info()));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
        
        IsSend=true;  
      } else {
        if(Minute()!=Minute_To_Send)
          IsSend=false;
      }
    }    
             
    Sleep(500); //������ ����� �� 0.5 ������� ����� ����� ��������� �����
    
    if(view=="....") { view="....."; Comment(view); continue; } 
    if(view=="...") { view="...."; Comment(view); continue; } 
    if(view=="..") { view="..."; Comment(view); continue; } 
    if(view==".") { view=".."; Comment(view); continue; } 
    if(view=="" || view==".....") { view="."; Comment(view); continue; } 
  } //end while ((IsExpertEnabled()) && (!IsStopped()) && (IsTesting()))
//----
   return(0);
} //end int start()
//|                                               ������� ������� ���������                                           |
//+-------------------------------------------------------------------------------------------------------------------+
  
//+-------------------------------------------------------------------------------------------------------------------+
//|                                          ������� ��������������� ���������                                        |
int deinit() {
//----
   
//----
  return(0);
} //end int deinit()
//|                                          ������� ��������������� ���������                                        |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                                        ���� A                                                     |  
void BLOCK_A() {
  
  if((Hour()==OP_Hour_A) && (Minute()==OP_Minute_A)) { //��������� �����
    double BUYSTOP_Price  = NormalizeDouble(iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,MinToFindHL_A,0))+N_BUYSTOP_A*Point,Digits);
    double SELLSTOP_Price = NormalizeDouble(iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,MinToFindHL_A,0))-N_SELLSTOP_A*Point,Digits);
    double SL_BUYSTOP, SL_SELLSTOP;
    
    if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL)
       && (BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
      //���� �� �������� �������� ���� ����� ��������� ���� �� ���� SELLSTOP_Price, �� ������ ���� �� SELLSTOP_Price
      SL_BUYSTOP  = SELLSTOP_Price;
      
      //���� ���������� ����� ����� ������� � ������ ������ �������� BUYSTOP_SL_A, �� ������ ���� �� ���������� BUYSTOP_SL_A
      if((BUYSTOP_Price-SL_BUYSTOP)/Point>BUYSTOP_SL_A)
        SL_BUYSTOP  = sl(BUYSTOP_SL_A, OP_BUYSTOP, BUYSTOP_Price);
    } else {
      //���� ���������� ��������� ���� �� SELLSTOP_Price, �� ������ ���� �� ���������� BUYSTOP_SL_A
      SL_BUYSTOP  = sl(BUYSTOP_SL_A, OP_BUYSTOP, BUYSTOP_Price);
    } //end if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL) .. (else)
    
    if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL)
       && (BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
      //���� �� �������� �������� ���� ����� ��������� ���� �� ���� BUYSTOP_Price, �� ������ ���� �� BUYSTOP_Price 
      SL_SELLSTOP = BUYSTOP_Price;
      
      //���� ���������� ����� ����� ������� � ������ ������ �������� SELLSTOP_SL_A, �� ������ ���� �� ���������� SELLSTOP_SL_A
      if((SL_SELLSTOP-SELLSTOP_Price)/Point>SELLSTOP_SL_A)
        SL_SELLSTOP = sl(SELLSTOP_SL_A, OP_SELLSTOP, SELLSTOP_Price);
    } else {
      //���� ���������� ��������� ���� �� BUYSTOP_Price, �� ������ ���� �� ���������� SELLSTOP_SL_A
      SL_SELLSTOP = sl(SELLSTOP_SL_A, OP_SELLSTOP, SELLSTOP_Price);
    } //end  if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL) .. (else)
    
    
    double TP_BUYSTOP  = tp(BUYSTOP_TP_A, OP_BUYSTOP, BUYSTOP_Price);
    double TP_SELLSTOP = tp(SELLSTOP_TP_A, OP_SELLSTOP, SELLSTOP_Price);
    
    string SMS_text="", temp_text="";
    if(!this_bar("A")) {
      if(!find_orders(MagicNumber_A)) {
        if((BUYSTOP_Price-Ask)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
          temp_text=open_positions(OP_BUYSTOP, BUYSTOP_Lots_A, SL_BUYSTOP, TP_BUYSTOP, MagicNumber_A, BUYSTOP_Price, "NONE", "����� ������");
        } else {
          temp_text=open_positions(OP_BUY, BUYSTOP_Lots_A, SL_BUYSTOP, TP_BUYSTOP, MagicNumber_A, 0.0, "NONE", "����� ������");
        } //end if((BUYSTOP_Price-Bid)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL))
        SMS_text=StringConcatenate(SMS_text,temp_text);
        if((Bid-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
          temp_text=open_positions(OP_SELLSTOP, SELLSTOP_Lots_A, SL_SELLSTOP, TP_SELLSTOP, MagicNumber_A, SELLSTOP_Price, "NONE", "����� ������");
        } else {
          temp_text=open_positions(OP_SELL, SELLSTOP_Lots_A, SL_SELLSTOP, TP_SELLSTOP, MagicNumber_A, 0.0, "NONE", "����� ������");
        } //end if((Ask-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL))
        SMS_text=StringConcatenate(SMS_text,temp_text);
        
      int ExCode[1];

        Print("���������� SMS ���������... "+Tel_Num_1);
        Print(SendSkypeSMS(ExCode, Tel_Num_1, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������"+StringLen(SMS_text));
        else
          Print("SMS ��������� ����������");
          
        Print("���������� SMS ���������... "+Tel_Num_2);
        Print(SendSkypeSMS(ExCode, Tel_Num_2, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
      } //end if(!find_orders(MagicNumber_A))
    } //end if(!this_bar())
  } //end if((Hour()==OP_Hour_A) && (Minute()==OP_Minute_A))
  
  stop_to_profit(MagicNumber_A, Profit_to_SL_A, SL_Profit_Level_A);
  
  if((Hour()==Close_Hour_A) && (Minute()==Close_Minute_A))
    cbm(MagicNumber_A,Slipage);
} //end void BLOCK_A()
//|                                                        ���� A                                                     |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                                        ���� B                                                     |
void BLOCK_B() {
  if((Hour()==OP_Hour_B) && (Minute()==OP_Minute_B)) { //��������� �����
    double BUYSTOP_Price  = NormalizeDouble(iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,MinToFindHL_B,0))+N_BUYSTOP_B*Point,Digits);
    double SELLSTOP_Price = NormalizeDouble(iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,MinToFindHL_B,0))-N_SELLSTOP_B*Point,Digits);
    double SL_BUYSTOP, SL_SELLSTOP;

    if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL)
       && (BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
      //���� �� �������� �������� ���� ����� ��������� ���� �� ���� SELLSTOP_Price, �� ������ ���� �� SELLSTOP_Price
      SL_BUYSTOP  = SELLSTOP_Price;
      
      //���� ���������� ����� ����� ������� � ������ ������ �������� BUYSTOP_SL_B, �� ������ ���� �� ���������� BUYSTOP_SL_B
      if((BUYSTOP_Price-SL_BUYSTOP)/Point>BUYSTOP_SL_B)
        SL_BUYSTOP  = sl(BUYSTOP_SL_B, OP_BUYSTOP, BUYSTOP_Price);
    } else {
      //���� ���������� ��������� ���� �� SELLSTOP_Price, �� ������ ���� �� ���������� BUYSTOP_SL_B
      SL_BUYSTOP  = sl(BUYSTOP_SL_B, OP_BUYSTOP, BUYSTOP_Price);
    } //end if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL) .. (else)
    
    if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL)
       && (BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
      //���� �� �������� �������� ���� ����� ��������� ���� �� ���� BUYSTOP_Price, �� ������ ���� �� BUYSTOP_Price 
      SL_SELLSTOP = BUYSTOP_Price;
      
      //���� ���������� ����� ����� ������� � ������ ������ �������� SELLSTOP_SL_B, �� ������ ���� �� ���������� SELLSTOP_SL_B
      if((SL_SELLSTOP-SELLSTOP_Price)/Point>SELLSTOP_SL_B)
        SL_SELLSTOP = sl(SELLSTOP_SL_B, OP_SELLSTOP, SELLSTOP_Price);
    } else {
      //���� ���������� ��������� ���� �� BUYSTOP_Price, �� ������ ���� �� ���������� SELLSTOP_SL_B
      SL_SELLSTOP = sl(SELLSTOP_SL_B, OP_SELLSTOP, SELLSTOP_Price);
    } //end if((BUYSTOP_Price-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL) .. (else)
    
    
    double TP_BUYSTOP  = tp(BUYSTOP_TP_B, OP_BUYSTOP, BUYSTOP_Price);
    double TP_SELLSTOP = tp(SELLSTOP_TP_B, OP_SELLSTOP, SELLSTOP_Price);
    string SMS_text="", temp_text="";
    if(!this_bar("B")) {
      GlobalVariableSet("BUYSTOP_Price"+Symbol()+Period(),BUYSTOP_Price);
      GlobalVariableSet("SL_BUYSTOP"+Symbol()+Period(),SL_BUYSTOP);
      GlobalVariableSet("TP_BUYSTOP"+Symbol()+Period(),TP_BUYSTOP);
    
      GlobalVariableSet("SELLSTOP_Price"+Symbol()+Period(),SELLSTOP_Price);
      GlobalVariableSet("SL_SELLSTOP"+Symbol()+Period(),SL_SELLSTOP);
      GlobalVariableSet("TP_SELLSTOP"+Symbol()+Period(),TP_SELLSTOP);
      
      if(!find_orders(MagicNumber_B)) {
        if((BUYSTOP_Price-Ask)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
          temp_text=open_positions(OP_BUYSTOP, BUYSTOP_Lots_B, SL_BUYSTOP, TP_BUYSTOP, MagicNumber_B, BUYSTOP_Price, "NONE", "����� ������");
        } else {
          temp_text=open_positions(OP_BUY, BUYSTOP_Lots_B, SL_BUYSTOP, TP_BUYSTOP, MagicNumber_B, 0.0, "NONE", "����� ������");
        } //end if((BUYSTOP_Price-Bid)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL))
        SMS_text=StringConcatenate(SMS_text,temp_text);
        if((Bid-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
          temp_text=open_positions(OP_SELLSTOP, SELLSTOP_Lots_B, SL_SELLSTOP, TP_SELLSTOP, MagicNumber_B, SELLSTOP_Price, "NONE", "����� ������");
        } else {
          temp_text=open_positions(OP_SELL, SELLSTOP_Lots_B, SL_SELLSTOP, TP_SELLSTOP, MagicNumber_B, 0.0, "NONE", "����� ������");
        } //end if((Ask-SELLSTOP_Price)/Point>MarketInfo(Symbol(),MODE_STOPLEVEL))
        SMS_text=StringConcatenate(SMS_text,temp_text);
      int ExCode[1];

        Print("���������� SMS ���������... "+Tel_Num_1);
        Print(SendSkypeSMS(ExCode, Tel_Num_1, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������"+StringLen(SMS_text));
        else
          Print("SMS ��������� ����������");
          
        Print("���������� SMS ���������... "+Tel_Num_2);
        Print(SendSkypeSMS(ExCode, Tel_Num_2, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
      } //end if(!find_orders(MagicNumber_B))
    } //end if(!this_bar())
  } //end if((Hour()==OP_Hour_B) && (Minute()==OP_Minute_B))
  
  /* ���� ���� �������� ������ BUY � ��� ������ SELL, � ����� ��� ������� SELLSTOP, �� ��������� �������
     � ������������ � ����� ����������� ����������� */
     temp_text="";
  if(find_orders(MagicNumber_B, OP_BUY)
     && !find_orders(MagicNumber_B, OP_SELL)
     && !find_orders(MagicNumber_B, OP_SELLSTOP)) {
    if((Bid-GlobalVariableGet("SELLSTOP_Price"+Symbol()+Period()))/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
      temp_text=open_positions(OP_SELLSTOP, SELLSTOP_Lots_B, GlobalVariableGet("SL_SELLSTOP"+Symbol()+Period()), GlobalVariableGet("TP_SELLSTOP"+Symbol()+Period()), MagicNumber_B, GlobalVariableGet("SELLSTOP_Price"+Symbol()+Period()), "NONE", "����� ������");
    } else {
      temp_text=open_positions(OP_SELL, SELLSTOP_Lots_B, GlobalVariableGet("SL_SELLSTOP"+Symbol()+Period()), GlobalVariableGet("TP_SELLSTOP"+Symbol()+Period()), MagicNumber_B, 0.0, "NONE", "����� ������");
    } //end if((Bid-GlobalVariableGet("SELLSTOP_Price"+Symbol()+Period()))/Point>MarketInfo(Symbol(),MODE_SPREAD)) (else)
    SMS_text=StringConcatenate(SMS_text,temp_text);
        Print("���������� SMS ���������... "+Tel_Num_1);
        Print(SendSkypeSMS(ExCode, Tel_Num_1, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������"+StringLen(SMS_text));
        else
          Print("SMS ��������� ����������");
          
        Print("���������� SMS ���������... "+Tel_Num_2);
        Print(SendSkypeSMS(ExCode, Tel_Num_2, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
  } //end if(find_orders(MagicNumber_B, OP_BUY) ..

  /* ���� ���� �������� ������ SELL � ��� ������ BUY, � ����� ��� ������� BUYSTOP, �� ��������� �������
     � ������������ � ����� ����������� ����������� */  
     temp_text="";
  if(find_orders(MagicNumber_B, OP_SELL)
     && !find_orders(MagicNumber_B, OP_BUY)
     && !find_orders(MagicNumber_B, OP_BUYSTOP)) {
    if((GlobalVariableGet("BUYSTOP_Price"+Symbol()+Period())-Ask)/Point>MarketInfo(Symbol(),MODE_SPREAD)) {
      temp_text=open_positions(OP_BUYSTOP, BUYSTOP_Lots_B, GlobalVariableGet("SL_BUYSTOP"+Symbol()+Period()), GlobalVariableGet("TP_BUYSTOP"+Symbol()+Period()), MagicNumber_B, GlobalVariableGet("BUYSTOP_Price"+Symbol()+Period()), "NONE", "����� ������");
    } else {
      temp_text=open_positions(OP_BUY, BUYSTOP_Lots_B, GlobalVariableGet("SL_BUYSTOP"+Symbol()+Period()), GlobalVariableGet("TP_BUYSTOP"+Symbol()+Period()), MagicNumber_B, 0.0, "NONE", "����� ������");
    } //end if((GlobalVariableGet("BUYSTOP_Price"+Symbol()+Period())-Ask)/Point>MarketInfo(Symbol(),MODE_SPREAD)) ..
    SMS_text=StringConcatenate(SMS_text,temp_text);
        Print("���������� SMS ���������... "+Tel_Num_1);
        Print(SendSkypeSMS(ExCode, Tel_Num_1, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������"+StringLen(SMS_text));
        else
          Print("SMS ��������� ����������");
          
        Print("���������� SMS ���������... "+Tel_Num_2);
        Print(SendSkypeSMS(ExCode, Tel_Num_2, SMS_text));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
  } //end if(find_orders(MagicNumber_B, OP_SELL) .. 
  
  stop_to_profit(MagicNumber_B, Profit_to_SL_B, SL_Profit_Level_B);
  
  if((Hour()==Close_Hour_B) && (Minute()==Close_Minute_B)) {
    GlobalVariableDel("BUYSTOP_Price"+Symbol()+Period());
    GlobalVariableDel("SELLSTOP_Price"+Symbol()+Period());
    cbm(MagicNumber_B,Slipage);
  } //end if((Hour()==Close_Hour_B) && (Minute()==Close_Minute_B))
} //end void BLOCK_B()
//|                                                        ���� B                                                     |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                            ������� ������������ ����� ��������� ������ �� ������ ����                             |
bool this_bar(string postfix) {
  if(
      (!GlobalVariableCheck("this_bar"+Symbol()+Period()+postfix))
      || (GlobalVariableGet("this_bar"+Symbol()+Period()+postfix)!=Time[0])
    ) {
    GlobalVariableSet("this_bar"+Symbol()+Period()+postfix,Time[0]);
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
    if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
    if(((OrderType()==type) || (type==-1))
       && ((OrderMagicNumber()==magic) || (magic==-1))
       && ((OrderSymbol()==Symbol() || (symb=="NONE")))) {
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
  if(symb=="NONE") symb=Symbol();
  if(type==OP_BUY)  price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS));
  if(type==OP_SELL) price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS));
  
  if(sl_value<=0) return(0);
  
  if(rmode==1) {
    if((type==OP_BUY) || (type==OP_BUYSTOP) || (type==OP_BUYLIMIT))     return(price-sl_value*MarketInfo(symb,MODE_POINT));
    if((type==OP_SELL) || (type==OP_SELLSTOP) || (type==OP_SELLLIMIT))  return(price+sl_value*MarketInfo(symb,MODE_POINT));
  } //end if(rmode==1)
  
  if(rmode==2) {
    if((type==OP_BUY) || (type==OP_BUYSTOP) || (type==OP_BUYLIMIT))     return(price-sl_value*MarketInfo(symb,MODE_POINT));
    if((type==OP_SELL) || (type==OP_SELLSTOP) || (type==OP_SELLLIMIT))  return(price+sl_value*MarketInfo(symb,MODE_POINT));
  } //end if(rmode==2)
} //end double sl(int sl_value, int type, double price=0.0, string symb="NONE", int rmode=1)
//|                                  ������� ������� �������� Stop Loss ��� �������                                   |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                 ������� ������� �������� Take Profit ��� �������                                  |
double tp(int tp_value, int type, double price=0.0, string symb="NONE") {
  if(symb=="NONE") symb=Symbol();
  if(type==OP_BUY)  price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS));
  if(type==OP_SELL) price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS));
  if(tp_value<=0) return(0);
  if((type==OP_BUY) || (type==OP_BUYSTOP) || (type==OP_BUYLIMIT))     return(price+tp_value*MarketInfo(symb,MODE_POINT));
  if((type==OP_SELL) || (type==OP_SELLSTOP) || (type==OP_SELLLIMIT))  return(price-tp_value*MarketInfo(symb,MODE_POINT));
} //end double tp(int tp_value, int type, double price=0.0, string symb="NONE")
//|                                 ������� ������� �������� Take Profit ��� �������                                  |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                              ������� �������� �������                                             |
string open_positions(int type, double lot, double sl, double tp, int magic=0, double price=0.0, string symb="NONE", string comm="") {
  /* extern */ int Count_Of_Trade_Try=5, //5 ������� ������� �����
                   Pause_Of_Trade_Try=5; //0.5 ������� ����� ���������

  int    i   = 0; //���������� ��� �������� �����
  string text_out="";

  if(symb=="NONE") symb=Symbol();
  if(type==0)
    price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS)); //���� �������� ��� �������
  if(type==1)
    price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS)); //���� �������� ��� ������

  while(i<=Count_Of_Trade_Try) {
    //���� ������ �������� ������ (����������). ��� �������� ���������� ��������� ��������� �� ������ ������:
    int ticket = OrderSend(Symbol(),                      //������
                           type,                          //��� ������
                           lot,                           //�����
                           NormalizeDouble(price,Digits), //���� ��������
                           Slipage,                       //������� ����������� �������
                           NormalizeDouble(sl,Digits),    //�������� Stop Loss
                           NormalizeDouble(tp,Digits),    //�������� Take Profit
                           comm,                          //����������� ������
                           magic,                         //���������� �����
                           0,                             //���� ��������� (������������ ��� ���������� �������)
                           CLR_NONE);                     //���� ������������ ������� �� ������� (CLR_NONE - ������� �� ��������)
    if(ticket!=-1) { //���� �������� ��������� �������, �� ������� �� �����
      text_out=StringConcatenate("Open OK: ",int_to_type(type),"; price: ",DoubleToStr(price,Digits),"; sl: ",DoubleToStr(sl,Digits),"; tp: ",DoubleToStr(tp,Digits),"; ");
      break;
     }  
    int err = GetLastError(); //��� ��������� ������  
    if(err!=0) {
      Print("������ ��������: "+Market_Err_To_Str(err),"; ���: ",type,"; Ask|Bid ",Ask,"|",Bid,"; price: ",price,"; sl: ",sl,"; tp: ",tp);
      text_out=StringConcatenate("Error: ",int_to_type(type)," : ",Market_Err_To_Str(err),"; ");
    }  
    i++;
    Sleep(Pause_Of_Trade_Try*100); //� ������ ������ ������ ����� ����� ����� ��������
  } //end while(i<=count)
  return(text_out);
} //end void open_positions(int signal, double lot, double price=0.0, string symb="NONE")
//|                                              ������� �������� �������                                             |
//+-------------------------------------------------------------------------------------------------------------------+
string int_to_type(int type) {
  switch(type) {
    case 0: return("BUY");
    case 1: return("SELL");
    case 2: return("BUY LIMIT");
    case 3: return("SELL LIMIT");
    case 4: return("BUY STOP");
    case 5: return("SELL STOP");
  }
}
//+-------------------------------------------------------------------------------------------------------+
//|                                      ������� ����������� ����� ������                                 |
string Market_Err_To_Str(int err) {
/* ������� ���������� ������ ���� ������ �������� �������� */
   string error_string;
//----
   switch(err)
     {
      //---- codes returned from trade server
      case 0:
      case 1:   error_string="no error";                                                  break;
      case 2:   error_string="common error";                                              break;
      case 3:   error_string="invalid trade parameters";                                  break;
      case 4:   error_string="trade server is busy";                                      break;
      case 5:   error_string="old version of the client terminal";                        break;
      case 6:   error_string="no connection with trade server";                           break;
      case 7:   error_string="not enough rights";                                         break;
      case 8:   error_string="too frequent requests";                                     break;
      case 9:   error_string="malfunctional trade operation (never returned error)";      break;
      case 64:  error_string="account disabled";                                          break;
      case 65:  error_string="invalid account";                                           break;
      case 128: error_string="trade timeout";                                             break;
      case 129: error_string="invalid price";                                             break;
      case 130: error_string="invalid stops";                                             break;
      case 131: error_string="invalid trade volume";                                      break;
      case 132: error_string="market is closed";                                          break;
      case 133: error_string="trade is disabled";                                         break;
      case 134: error_string="not enough money";                                          break;
      case 135: error_string="price changed";                                             break;
      case 136: error_string="off quotes";                                                break;
      case 137: error_string="broker is busy (never returned error)";                     break;
      case 138: error_string="requote";                                                   break;
      case 139: error_string="order is locked";                                           break;
      case 140: error_string="long positions only allowed";                               break;
      case 141: error_string="too many requests";                                         break;
      case 145: error_string="modification denied because order too close to market";     break;
      case 146: error_string="trade context is busy";                                     break;
      case 147: error_string="expirations are denied by broker";                          break;
      case 148: error_string="amount of open and pending orders has reached the limit";   break;
      case 149: error_string="hedging is prohibited";                                     break;
      case 150: error_string="prohibited by FIFO rules";                                  break;
      //---- mql4 errors
      case 4000: error_string="no error (never generated code)";                          break;
      case 4001: error_string="wrong function pointer";                                   break;
      case 4002: error_string="array index is out of range";                              break;
      case 4003: error_string="no memory for function call stack";                        break;
      case 4004: error_string="recursive stack overflow";                                 break;
      case 4005: error_string="not enough stack for parameter";                           break;
      case 4006: error_string="no memory for parameter string";                           break;
      case 4007: error_string="no memory for temp string";                                break;
      case 4008: error_string="not initialized string";                                   break;
      case 4009: error_string="not initialized string in array";                          break;
      case 4010: error_string="no memory for array\' string";                             break;
      case 4011: error_string="too long string";                                          break;
      case 4012: error_string="remainder from zero divide";                               break;
      case 4013: error_string="zero divide";                                              break;
      case 4014: error_string="unknown command";                                          break;
      case 4015: error_string="wrong jump (never generated error)";                       break;
      case 4016: error_string="not initialized array";                                    break;
      case 4017: error_string="dll calls are not allowed";                                break;
      case 4018: error_string="cannot load library";                                      break;
      case 4019: error_string="cannot call function";                                     break;
      case 4020: error_string="expert function calls are not allowed";                    break;
      case 4021: error_string="not enough memory for temp string returned from function"; break;
      case 4022: error_string="system is busy (never generated error)";                   break;
      case 4050: error_string="invalid function parameters count";                        break;
      case 4051: error_string="invalid function parameter value";                         break;
      case 4052: error_string="string function internal error";                           break;
      case 4053: error_string="some array error";                                         break;
      case 4054: error_string="incorrect series array using";                             break;
      case 4055: error_string="custom indicator error";                                   break;
      case 4056: error_string="arrays are incompatible";                                  break;
      case 4057: error_string="global variables processing error";                        break;
      case 4058: error_string="global variable not found";                                break;
      case 4059: error_string="function is not allowed in testing mode";                  break;
      case 4060: error_string="function is not confirmed";                                break;
      case 4061: error_string="send mail error";                                          break;
      case 4062: error_string="string parameter expected";                                break;
      case 4063: error_string="integer parameter expected";                               break;
      case 4064: error_string="double parameter expected";                                break;
      case 4065: error_string="array as parameter expected";                              break;
      case 4066: error_string="requested history data in update state";                   break;
      case 4099: error_string="end of file";                                              break;
      case 4100: error_string="some file error";                                          break;
      case 4101: error_string="wrong file name";                                          break;
      case 4102: error_string="too many opened files";                                    break;
      case 4103: error_string="cannot open file";                                         break;
      case 4104: error_string="incompatible access to a file";                            break;
      case 4105: error_string="no order selected";                                        break;
      case 4106: error_string="unknown symbol";                                           break;
      case 4107: error_string="invalid price parameter for trade function";               break;
      case 4108: error_string="invalid ticket";                                           break;
      case 4109: error_string="trade is not allowed in the expert properties";            break;
      case 4110: error_string="longs are not allowed in the expert properties";           break;
      case 4111: error_string="shorts are not allowed in the expert properties";          break;
      case 4200: error_string="object is already exist";                                  break;
      case 4201: error_string="unknown object property";                                  break;
      case 4202: error_string="object is not exist";                                      break;
      case 4203: error_string="unknown object type";                                      break;
      case 4204: error_string="no object name";                                           break;
      case 4205: error_string="object coordinates error";                                 break;
      case 4206: error_string="no specified subwindow";                                   break;
      default:   error_string="unknown error";
     }
//----
   return(error_string);
} //end string Err_To_Str(int err)
//|                                      ������� ����������� ����� ������                                 |
//+-------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                          ������� �������� ����� � ���������                                       |
void stop_to_profit(int magic, int profit_level, int sl_level) {
  int i=0, n=0, ticket=0 , type=-1, magic_num=0;
  string symb="";
  double open_price=0.0, tp=0.0, sl=0.0;
  for(i=OrdersTotal()-1; i>=0; i--) {
    if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
    ticket     = OrderTicket();
    open_price = NormalizeDouble(OrderOpenPrice(),Digits);
    type       = OrderType();
    tp         = NormalizeDouble(OrderTakeProfit(),Digits);
    sl         = NormalizeDouble(OrderStopLoss(),Digits);
    symb       = OrderSymbol();
    magic_num  = OrderMagicNumber();
    if((symb==Symbol())&&(magic_num==magic)) {
      if(type==OP_BUY) {   
        if(GlobalVariableCheck("Mod_SL_"+ticket)) {
          if(iBarShift(Symbol(),0,GlobalVariableGet("Mod_SL_"+ticket))==1) {
            if(((NormalizeDouble(sl,Digits)!=NormalizeDouble(open_price+sl_level*MarketInfo(symb,MODE_POINT),Digits)))) {
              //���� ������ ��������� ��������� ���� � ���������
              if(!OrderModify(ticket,
                          open_price,
                          NormalizeDouble(open_price+sl_level*Point,Digits),
                          tp,
                          OrderExpiration(),
                          CLR_NONE)) {
                if((open_price>MarketInfo(symb,MODE_BID))
                   || ((MarketInfo(symb,MODE_BID)-open_price)/Point<MarketInfo(symb,MODE_STOPLEVEL))) {
                  //���� ������ �� ��������� ��������� ���� � ���������   
                  if(close_by_ticket(ticket, Slipage)) {
                    //SMS � ��������� ���������� ����� � �������� ������
                    GlobalVariableDel("Mod_SL_"+ticket);
                    continue;   
                  } //end if(close_by_ticket(ticket, Slipage))
                } //end if((open_price>MarketInfo(symb,MODE_BID)) ..
              } else {
                //SMS �� ������� ���������� �����
                GlobalVariableDel("Mod_SL_"+ticket);
                continue; 
              } //end if(!OrderModify(ticket, .. (else)         
            } //end if(((NormalizeDouble(sl,Digits)!=NormalizeDouble(open_price+sl_level*MarketInfo(symb,MODE_POINT),Digits))))
          } //end if(iBarShift(Symbol(),0,GlobalVariableGet("Mod_SL_"+ticket))==1)         
        } //end if(GlobalVariableCheck("Mod_SL_"+ticket))
       
        if(((MarketInfo(symb,MODE_BID)-open_price>=profit_level*MarketInfo(symb,MODE_POINT))
           && (NormalizeDouble(sl,Digits)!=NormalizeDouble(open_price+sl_level*MarketInfo(symb,MODE_POINT),Digits)))) {
            GlobalVariableSet("Mod_SL_"+ticket,Time[0]);     
        } //end if(((MarketInfo(symb,MODE_BID)-open_price>=profit_level*MarketInfo(symb,MODE_POINT)) ..
      } //end if(OrderType()==OP_BUY)

      if(type==OP_SELL) {
        if(GlobalVariableCheck("Mod_SL_"+ticket)) {
          if(iBarShift(Symbol(),0,GlobalVariableGet("Mod_SL_"+ticket))==1) {
            if(((NormalizeDouble(sl,Digits)!=NormalizeDouble(open_price-sl_level*MarketInfo(symb,MODE_POINT),Digits)))) {
              Print(NormalizeDouble(sl,Digits)," ",NormalizeDouble(open_price+sl_level*MarketInfo(symb,MODE_POINT),Digits)); 
              RefreshRates();
              if(!OrderModify(ticket,
                          open_price,
                          NormalizeDouble(open_price-sl_level*Point,Digits),
                          tp,
                          OrderExpiration(),
                          CLR_NONE)) {
                if((open_price<MarketInfo(symb,MODE_ASK)) 
                   || ((open_price-MarketInfo(symb,MODE_ASK))/Point<MarketInfo(symb,MODE_STOPLEVEL))) {
                  //���� ������ �� ��������� ��������� ���� � ���������   
                  if(close_by_ticket(ticket, Slipage)) {
                    //SMS � ��������� ���������� ����� � �������� ������
                    GlobalVariableDel("Mod_SL_"+ticket);
                    continue;   
                  } //end if(close_by_ticket(ticket, Slipage))
                } //end if((open_price<MarketInfo(symb,MODE_ASK)) ..
              } else {
                //SMS �� ������� ���������� �����
                GlobalVariableDel("Mod_SL_"+ticket);
                continue;   
              } //end if(!OrderModify(ticket, .. (else)
            } //end if(((NormalizeDouble(sl,Digits)!=NormalizeDouble(open_price-sl_level*MarketInfo(symb,MODE_POINT),Digits))))
          }               
        } 
       
        if(((open_price-MarketInfo(symb,MODE_ASK)>=profit_level*MarketInfo(symb,MODE_POINT)) 
           && (NormalizeDouble(sl,Digits)!=NormalizeDouble(open_price-sl_level*MarketInfo(symb,MODE_POINT),Digits)))) {
             GlobalVariableSet("Mod_SL_"+ticket,Time[0]); 
          //Print("Sell: "+(open_price-MarketInfo(OrderSymbol(),MODE_ASK))/Point);
        }
      } //end if(OrderType()==OP_SELL)
    } //end if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number))
  } //end for(i=OrdersTotal()-1; i>=0; i--) {
} //end void stop_to_profit()
//|                                          ������� �������� ����� � ���������                                       |
//+-------------------------------------------------------------------------------------------------------------------+


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
      int ExCode[1];
      if(ticket) { //���� �������� ��� �������� ������ ������� - ���������� true � ������� �� �����
        Print("���������� SMS ���������... "+Tel_Num_1);
        Print(SendSkypeSMS(ExCode, Tel_Num_1, StringConcatenate("Close OK: ",int_to_type(OrderType()))));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
          
        Print("���������� SMS ���������... "+Tel_Num_2);
        Print(SendSkypeSMS(ExCode, Tel_Num_2, StringConcatenate("Close OK: ",int_to_type(OrderType()))));
        if(ExCode[0] == -1)
          Print("������ �������� SMS ���������");
        else
          Print("SMS ��������� ����������");
        return(true);
        break;
      } //end if(ticket)
      err=GetLastError();
      if(err!=0) Print("������: "+Market_Err_To_Str(err));
      Sleep(Pause_Of_Trade_Try*100); //� ������ ������ ������ ����� ����� ����� ��������
    } //end for(i=0;i<=Count_Of_Trade_Try;i++)
  } //end if(OrderSelect(c_ticket,SELECT_BY_TICKET,MODE_TRADES))

  return(false); //���������� false
} //end bool close_by_ticket(int c_ticket)
//|                           ������� �������� ������ �� � ������ (������)                            |
//+----------------------------------------------------------------------------------------------------+

bool cbm(int magic, int slipage, int type=-1) {
  /*
    close by magic (�������� ���� ������� ������� ���� � ������ MagicNumber)
    ����������� ����������� ���������� ��������������� (slipage)
    ������������ ������� close_by_ticket.
  */
  int n = 0;
  while (find_orders(magic, type))
    for (int i2=OrdersTotal()-1; i2>=0; i2--) {
      if (!OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)) break;

      if (((OrderType()==type) || (type==-1))
          && (OrderMagicNumber()==magic)) {
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

string str_acc_info() {
  string text="";
  text=text+"Balance: "+DoubleToStr(AccountBalance(),2)+"; ";
  text=text+"Equity: "+DoubleToStr(AccountEquity(),2)+";";
  
  int c_of_orders=0, profit_pp=0;
  double profit_cur=0.0;
  
  for (int i=OrdersTotal()-1; i>=0; i--) {
    if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
    c_of_orders++;
    profit_cur+=OrderProfit()+OrderCommission()+OrderSwap();
    if(OrderType()==OP_BUY)
      profit_pp+=NormalizeDouble(Bid-OrderOpenPrice(),Digits)/Point;
    if(OrderType()==OP_SELL)
      profit_pp+=NormalizeDouble(OrderOpenPrice()-Ask,Digits)/Point;
  } //end for (int i=OrdersTotal()-1; i>=0; i--)
  text=text+"Num of orders: "+c_of_orders+"; ";
  text=text+"Profit (in pp): "+profit_pp+"; ";
  text=text+"Profit (in cur.): "+DoubleToStr(profit_cur,2)+";";
  
  return(text);
} //end string str_acc_info()