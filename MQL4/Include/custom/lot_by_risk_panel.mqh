#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>
#include <Controls/Edit.mqh>

class lot_by_risk : public CAppDialog{
private:
    CLabel lb_cmnt_, lb_risk_;
    CEdit ed_cmnt_, ed_risk_;
    CButton bt_trade_, bt_close_;

public:
    bool Create(const long chart, const string name, const int subwin, const int x, const int y, const int w, const int h, const ENUM_BASE_CORNER corner);

private:
    void SetCorner(int& x, int& y, const int w, const int h, const ENUM_BASE_CORNER corner);
};

bool lot_by_risk::Create(const long chart, const string name, const int subwin, const int x, const int y, const int x, const int y, const ENUM_BASE_CORNER corner){

    if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2)){
        return (false);
    }
    
    return (true);
}

void lot_by_risk::SetCorner(int& x, int& y, const int w, const int h, const ENUM_BASE_CORNER corner){
   switch(corner){
      case CORNER_RIGHT_UPPER:
         x += w;
      break;
      case CORNER_LEFT_LOWER:
         y += h;
      break;
      case CORNER_RIGHT_LOWER:
         x += w;
         y += h;
      break;      
   }
}