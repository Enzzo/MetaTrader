#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Defines.mqh>

//  +-------------------------------------------------------------------------------+
//  |   class LbrView                                                               |
//  +-------------------------------------------------------------------------------+
//  |   Класс, в котором мы строим наше графическое окно с полями, кнопками и т.д.  |
//  +-------------------------------------------------------------------------------+
//  |   Так же этот класс отрисовывает все линии на графике и в деструкторе всё     |
//  |   чистит за собой                                                             |
//  +-------------------------------------------------------------------------------+

struct LbrInputs{
    long chart;
    string name;
    int subwin;
    int x, y, w, h;
    ENUM_BASE_CORNER corner;
    int font;
    string risk, comment;
};

class LbrView : public CAppDialog{
public:
    LbrView();
    ~LbrView();

    //  bool Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner, const int font);
    bool Create(const LbrInputs& inp);

    void Redraw();

private:
    bool LabelCmntCreate();
    bool LabelRiskCreate();
    bool EditCmntCreate();
    bool EditRiskCreate();
    bool ButtonOpenCreate();
    bool ButtonCloseCreate();

private:
    int         _font;
    string      _prefix;
    string      _text_risk,     _text_comment;
    datetime    _hline_open,    _hline_close;
    double      _vline_tp,      _vline_sl,      _vline_open;
    CLabel      _lb_comment,    _lb_risk;
    CEdit       _ed_comment,    _ed_risk;
    CButton     _bt_trade,      _bt_close;
};

LbrView::LbrView(){

}

LbrView::~LbrView(){}

//  bool LbrView::Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner, const int font){
bool LbrView::Create(const LbrInputs& inp){
    int x1 = inp.x;
    int y1 = inp.y;
    int x2 = inp.x + inp.w;
    int y2 = inp.y + inp.h;

    int width   = (int)ChartGetInteger(inp.chart, CHART_WIDTH_IN_PIXELS, 0);
    int height  = (int)ChartGetInteger(inp.chart, CHART_HEIGHT_IN_PIXELS, 0);

    switch(inp.corner){
        case CORNER_RIGHT_UPPER:
            x1 = width - (inp.w + x1);
            x2 = width - x2 + inp.w;
        break;
        case CORNER_LEFT_LOWER:
            y1 = height - (inp.h + y1);
            y2 = height - y2 + inp.h;
        break;
        case CORNER_RIGHT_LOWER:
            x1 = width - (inp.w + x1);
            x2 = width - x2 + inp.w;
            y1 = height - (inp.h + y1);
            y2 = height - y2 + inp.h;
        break;
    }
    if(!CAppDialog::Create(inp.chart, inp.name, inp.subwin, x1, y1, x2, y2)){
        return (false);
    }

    _prefix = Name();
    _font = inp.font;

    if(!LabelCmntCreate())      return false;
    if(!LabelRiskCreate())      return false;
    if(!EditCmntCreate())       return false;
    if(!EditRiskCreate())       return false;
    if(!ButtonOpenCreate())     return false;
    if(!ButtonCloseCreate())    return false;

    return (true);
}

bool LbrView::LabelCmntCreate(){
    if(!_lb_comment.Create(0, _prefix + "label_cmnt", 0, 4, 2, 1, 1)) return (false);
    if(!_lb_comment.FontSize(_font)) return (false);
    if(!_lb_comment.Text("Comment:")) return (false);
    if(!Add(_lb_comment)) return (false);
    return (true);
}

bool LbrView::LabelRiskCreate(){
    if(!_lb_risk.Create(0, _prefix + "label_risk", 0, 4, 20, 1, 1)) return (false);
    if(!_lb_risk.FontSize(_font)) return (false);
    if(!_lb_risk.Text("Risk:")) return (false);
    if(!Add(_lb_risk)) return (false);
    return (true);
}

bool LbrView::EditCmntCreate(){
    if(!_ed_comment.Create(0, _prefix + "edit_cmnt", 0, 50, 4, 98, 20)) return (false);
    if(!_ed_comment.FontSize(_font)) return (false);
    if(!_ed_comment.Text(_text_comment)) return (false);
    if(!Add(_ed_comment)) return (false);
    return (true);
}

bool LbrView::EditRiskCreate(){
    if(!_ed_risk.Create(0, _prefix + "edit_risk", 0, 50, 22, 98, 40)) return (false);
    if(!_ed_risk.FontSize(_font)) return (false);
    if(!_ed_risk.Text(_text_risk)) return (false);
    if(!Add(_ed_risk)) return (false);
    return (true);
}

bool LbrView::ButtonOpenCreate(){
    if(!_bt_trade.Create(0, _prefix + "button_trade", 0, 4, 42, 98, 58)) return (false);
    if(!_bt_trade.FontSize(_font)) return (false);
    if(!_bt_trade.Text("Trade")) return (false);
    if(!_bt_trade.ColorBackground(C'33,218,51')) return (false);
    if(!Add(_bt_trade)) return (false);
    return (true);
}

bool LbrView::ButtonCloseCreate(){
    if(!_bt_close.Create(0, _prefix + "button_close", 0, 4, 60, 98, 76)) return (false);
    if(!_bt_close.FontSize(_font)) return (false);
    if(!_bt_close.Text("Close")) return (false);
    if(!_bt_close.ColorBackground(clrRed)) return (false);
    if(!Add(_bt_close)) return (false);
    return (true);
}