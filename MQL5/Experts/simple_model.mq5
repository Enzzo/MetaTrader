//+------------------------------------------------------------------+
//|                                            ch01_simple_model.mq5 |
//|                            Copyright 2010, Vasily Sokolov (C-4). |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, Vasily Sokolov (C-4)."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Arrays\List.mqh>

// Base model
class CModel:CObject
{
protected:
   string            m_name;
public:
	void              CModel(){m_name="Model base";}
	bool virtual      Processing(void){return(true);}
};

class cmodel_macd : public CModel
{
public:
   void              cmodel_macd(){m_name="MACD Model";}
   bool              Processing(){Print("Processing ", m_name, "...");return(true);}
};

class cmodel_moving : public CModel
{
public:
   void              cmodel_moving(){m_name="Moving Average";}
   bool              Processing(){Print("Prosessing ", m_name, "...");return(true);}
};

//Great list of models
CList *list_models;

void OnInit()
{
   int rezult;
   // Great two pointer
   cmodel_macd          *m_macd;
   cmodel_moving        *m_moving;
   list_models =        new CList();
   m_macd   =           new cmodel_macd();
   m_moving =           new cmodel_moving();
   if(CheckPointer(m_macd)==POINTER_DYNAMIC){
      rezult=list_models.Add(m_macd);
      if(rezult!=-1)Print("Model MACD was great  successfully");
      else            Print("Model MACD was great failed");
   }
   if(CheckPointer(m_moving)==POINTER_DYNAMIC){
      rezult=list_models.Add(m_moving);
      if(rezult!=-1)Print("Model MOVING AVERAGE was great  successfully");
      else            Print("Model MOVING AVERAGE was great failed");
   }
}

void OnTick()
{
   CModel               *current_model;
   for(int i=0;i<list_models.Total();i++){
      current_model=list_models.GetNodeAtIndex(i);
      current_model.Processing();
   }
}

void OnDeinit(const int reason)
{
   delete list_models;
}