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

class LbrView{
public:
    LbrView();
    void Redraw();

private:
    CLabel  _lb_comment, _lb_risk;
    CEdit   _ed_comment, _ed_risk;
    CButton _bt_trade, _bt_close;
};