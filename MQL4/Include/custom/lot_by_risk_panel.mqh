#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>
#include <Controls/Edit.mqh>

class lot_by_risk : public CAppDialog{
private:
    string prefix_;
    CLabel lb_cmnt_, lb_risk_;
    CEdit ed_cmnt_, ed_risk_;
    CButton bt_trade_, bt_close_;

public:
    bool Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner);

protected:
    bool LabelCmntCreate();
    bool LabelRiskCreate();
    bool EditCmntCreate();
    bool EditRiskCreate();
    bool ButtonOpenCreate();
    bool ButtonCloseCreate();
};

bool lot_by_risk::Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner){

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
    if(!lb_cmnt_.Text("Comment:")) return (false);
    if(!Add(lb_cmnt_)) return (false);
    return (true);
}

bool lot_by_risk::LabelRiskCreate(){
    if(!lb_risk_.Create(0, prefix_ + "label_risk", 0, 4, 20, 1, 1)) return (false);
    if(!lb_risk_.Text("Risk:")) return (false);
    if(!Add(lb_risk_)) return (false);
    return (true);
}

bool lot_by_risk::EditCmntCreate(){
    if(!ed_cmnt_.Create(0, prefix_ + "edit_cmnt", 0, 50, 2, 98, 18)) return (false);
    if(!Add(ed_cmnt_)) return (false);
    return (true);
}

bool lot_by_risk::EditRiskCreate(){
    if(!ed_risk_.Create(0, prefix_ + "edit_risk", 0, 50, 22, 98, 40)) return (false);
    if(!Add(ed_risk_)) return (false);
    return (true);
}

bool lot_by_risk::ButtonOpenCreate(){
    return true;
}

bool lot_by_risk::ButtonCloseCreate(){
    return true;
}