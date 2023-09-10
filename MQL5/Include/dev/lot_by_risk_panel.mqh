#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Defines.mqh>

typedef bool (*CallBack)();

class lot_by_risk : public CAppDialog{
private:
    string prefix_, comment_text_, risk_text_;
    int font_;
    CLabel lb_cmnt_, lb_risk_;
    CEdit ed_cmnt_, ed_risk_;
    CButton bt_trade_, bt_close_;

public:
    lot_by_risk(){};
   ~lot_by_risk(){};

    void SetCommentDefault(const string comment){comment_text_ = comment;};
    void SetRiskDefault(const string risk){risk_text_ = risk;};

    bool Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner, const int font);

    virtual bool OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);

    void SetFooTrade(CallBack ft) { Trade = ft;};
    void SetFooClose(CallBack fc) { Close = fc;};

    double GetRisk() const;
    string GetComment() const;

protected:
    bool LabelCmntCreate();
    bool LabelRiskCreate();
    bool EditCmntCreate();
    bool EditRiskCreate();
    bool ButtonOpenCreate();
    bool ButtonCloseCreate();

private:
    CallBack Trade;
    CallBack Close;
};

bool lot_by_risk::Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner, const int font){

    int x1 = x;
    int y1 = y;
    int x2 = x + w;
    int y2 = y + h;

    int width   = (int)ChartGetInteger(chart, CHART_WIDTH_IN_PIXELS, 0);
    int height  = (int)ChartGetInteger(chart, CHART_HEIGHT_IN_PIXELS, 0);

    switch(corner){
        case CORNER_RIGHT_UPPER:
            x1 = width - (w + x1);
            x2 = width - x2 + w;
        break;
        case CORNER_LEFT_LOWER:
            y1 = height - (h + y1);
            y2 = height - y2 + h;
        break;
        case CORNER_RIGHT_LOWER:
            x1 = width - (w + x1);
            x2 = width - x2 + w;
            y1 = height - (h + y1);
            y2 = height - y2 + h;
        break;
    }
    if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2)){
        return (false);
    }

    prefix_ = Name();
    font_ = font;

    if(!LabelCmntCreate())      return false;
    if(!LabelRiskCreate())      return false;
    if(!EditCmntCreate())       return false;
    if(!EditRiskCreate())       return false;
    if(!ButtonOpenCreate())     return false;
    if(!ButtonCloseCreate())    return false;

    return (true);
}

bool lot_by_risk::LabelCmntCreate(){
    if(!lb_cmnt_.Create(0, prefix_ + "label_cmnt", 0, 4, 2, 1, 1)) return (false);
    if(!lb_cmnt_.FontSize(font_)) return (false);
    if(!lb_cmnt_.Text("Comment:")) return (false);
    if(!Add(lb_cmnt_)) return (false);
    return (true);
}

bool lot_by_risk::LabelRiskCreate(){
    if(!lb_risk_.Create(0, prefix_ + "label_risk", 0, 4, 20, 1, 1)) return (false);
    if(!lb_risk_.FontSize(font_)) return (false);
    if(!lb_risk_.Text("Risk:")) return (false);
    if(!Add(lb_risk_)) return (false);
    return (true);
}

bool lot_by_risk::EditCmntCreate(){
    if(!ed_cmnt_.Create(0, prefix_ + "edit_cmnt", 0, 50, 4, 98, 20)) return (false);
    if(!ed_cmnt_.FontSize(font_)) return (false);
    if(!ed_cmnt_.Text(comment_text_)) return (false);
    if(!Add(ed_cmnt_)) return (false);
    return (true);
}

bool lot_by_risk::EditRiskCreate(){
    if(!ed_risk_.Create(0, prefix_ + "edit_risk", 0, 50, 22, 98, 40)) return (false);
    if(!ed_risk_.FontSize(font_)) return (false);
    if(!ed_risk_.Text(risk_text_)) return (false);
    if(!Add(ed_risk_)) return (false);
    return (true);
}

bool lot_by_risk::ButtonOpenCreate(){
    if(!bt_trade_.Create(0, prefix_ + "button_trade", 0, 4, 42, 98, 58)) return (false);
    if(!bt_trade_.FontSize(font_)) return (false);
    if(!bt_trade_.Text("Trade")) return (false);
    if(!bt_trade_.ColorBackground(C'33,218,51')) return (false);
    if(!Add(bt_trade_)) return (false);
    return (true);
}

bool lot_by_risk::ButtonCloseCreate(){
    if(!bt_close_.Create(0, prefix_ + "button_close", 0, 4, 60, 98, 76)) return (false);
    if(!bt_close_.FontSize(font_)) return (false);
    if(!bt_close_.Text("Close")) return (false);
    if(!bt_close_.ColorBackground(clrRed)) return (false);
    if(!Add(bt_close_)) return (false);
    return (true);
}

double lot_by_risk::GetRisk() const {
    string sr = ed_risk_.Text();
    StringReplace(sr, ",", ".");
    return NormalizeDouble(StringToDouble(sr), 2);
}

string lot_by_risk::GetComment() const{
    return ed_cmnt_.Text();
}

bool lot_by_risk::OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam) {
    if(id==(ON_CLICK+CHARTEVENT_CUSTOM) && lparam==bt_trade_.Id()) { Trade(); return(true); }
    if(id==(ON_CLICK+CHARTEVENT_CUSTOM) && lparam==bt_close_.Id()) { Close(); return(true); }
    return(CAppDialog::OnEvent(id,lparam,dparam,sparam)); 
}