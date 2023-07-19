#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/enzzo"
#property version   "1.00"
// https://www.mql5.com/ru/articles/217

#include <dev/model/model.mqh>
#include <Arrays/List.mqh>

class cmodel_macd : public CModel{
public:
    cmodel_macd(){m_name = "MACD model";}
    virtual bool Processing(){Print(m_name); return (true);};
};

class cmodel_moving : public CModel{
public:
    cmodel_moving(){m_name = "moving model";}
    virtual bool Processing(){Print(m_name); return (true);};
};

CList* list_models;

int OnInit(){
    int result;

    list_models = new CList();
    cmodel_macd* m_macd = new cmodel_macd();
    cmodel_moving* m_moving = new cmodel_moving();

    if(CheckPointer(m_macd) == POINTER_DYNAMIC){
        result = list_models.Add(m_macd);
        if(result != -1){
            Print("Model MACD has successfully created");
        }
        else{
            Print("Creation of model MACD has failed");
        }
    }
    if(CheckPointer(m_moving) == POINTER_DYNAMIC){
        result = list_models.Add(m_moving);
        if(result != -1){
            Print("Model Moving has successfully created");
        }
        else{
            Print("Creation of model Moving has failed");
        }
    }

    return (INIT_SUCCEEDED);
}

void OnTick(){
    CModel* current_model;
    for(int i = list_models.Total()-1; i >= 0; --i){
        current_model = list_models.GetNodeAtIndex(i);
        current_model.Processing();
    }
}

void OnDeinit(const int reason){
    delete list_models;
}