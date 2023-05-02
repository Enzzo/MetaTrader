//+------------------------------------------------------------------+
//|                                                test_controls.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"

#include <Controls/Button.mqh>
#include <Controls/Dialog.mqh>

typedef int(*TAction)(string, int);

int Open(string name, int id){
   PrintFormat("Вызвана функция %s (name=%s id=%d)", __FUNCTION__, name, id);
   return (1);
}

int Sv(string name, int id){
   PrintFormat("Вызвана функция %s (name=%s, id=%d)", __FUNCTION__, name, id);
   return (2);
}

int Close(string name, int id){
   PrintFormat("Вызвана функция %s (name=%s, id=%d)", __FUNCTION__, name, id);
   return (3);
}

class MyButton: public CButton{
   TAction m_action;
public:
   MyButton(void){};
   ~MyButton(void){};
   
   //--- Конструктор с указанием текста кнопки и указателя на функцию для обработки события
   MyButton(string text, TAction act){
      Text(text);
      m_action=act;
   }
   
   void SetAction(TAction act){m_action=act;}
   
   virtual bool OnEvent(const int id, const long &lparam, const double &dparam, const string& sparam) override{
      if(m_action!=NULL && lparam==Id()){
         m_action(sparam, (int)lparam);
         return (true);
      }
      else{
         return (CButton::OnEvent(id,lparam,dparam,sparam));
      }
   }
};

class CControlsDialog : public CAppDialog{
   CArrayObj m_buttons; // массив кнопок
public:
   CControlsDialog(void){};
   ~CControlsDialog(void){};
   
   virtual bool Create(const long chart, const string name, const int subwindow, const int x1, const int y1, const int x2, const int y2);
   bool AddButton(MyButton &button) {
      if(m_buttons.Add(GetPointer(button))){
         m_buttons.Sort();
         return (true);
      }
      return(false);
   };
   bool CreateButtons(void);
};

bool CControlsDialog::Create(const long chart, const string name, const int subwindow, const int x1, const int y1, const int x2, const int y2){
   if(!CAppDialog::Create(chart, name, subwindow, x1, y1, x2, y2)){
      return (false);
   }
   return (CreateButtons());
};

#define INDENT_LEFT (11)
#define INDENT_TOP (11)
#define CONTROLS_GAP_X (5)
#define CONTROLS_GAP_Y (5)

#define BUTTON_WIDTH (100)
#define BUTTON_HEIGHT (20)

#define EDIT_HEIGHT (20)

bool CControlsDialog::CreateButtons(void){
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2;
   int y2=y1+BUTTON_HEIGHT;
   
   AddButton(new MyButton("Open", Open));
   AddButton(new MyButton("Open", Sv));
   AddButton(new MyButton("Open", Close));
   
   for(int i = 0; i < m_buttons.Total(); ++i){
      MyButton* b=(MyButton*)m_buttons.At(i);
      x1 = INDENT_LEFT+i*(BUTTON_WIDTH+CONTROLS_GAP_X);
      x2=x1+BUTTON_WIDTH;
      if(!b.Create(m_chart_id, m_name+"bt"+b.Text(),m_subwin,x1, y1, x2, y2)){
         PrintFormat("Failed to create button %s %d", b.Text(),i);
         return (false);
      }
      if(!Add(b)){
         return (false);
      }
   }
   return (true);
}

CControlsDialog MyDialog;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   if(!MyDialog.Create(0, "Controls", 0, 40, 40, 380, 344)){
      return (INIT_FAILED);
   }
   
   MyDialog.Run();
//---
   return 0;
};
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   MyDialog.Destroy(reason);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam){
                  
   MyDialog.ChartEvent(id, lparam, dparam, sparam);
}