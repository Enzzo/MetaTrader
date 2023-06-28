#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property description "Панель меняет свою прозрачность при перемещении"

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>

#define XRGB(r, g, b)   (0xFF000000 | uchar(r)<<16 | (uchar(g)<<8) | uchar(b))
#define GETRGB(clr)     ((clr) & 0xFFFFFFFF)

#define INDENT_LEFT         (11)
#define INDENT_TOP          (11)
#define CONTROLS_GAP_X      (5)
#define BUTTON_WIDTH        (100)
#define BUTTON_HEIGHT       (20)

class CLivePanelAndButton : public CAppDialog{
public:
    CLivePanel(){};
    ~CLivePanel(){};

    virtual bool Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2) override;

    virtual bool OnDialogDragStart() override;
    // virtual bool OnDialogDragProcess() override;
    virtual bool OnDialogDragEnd() override;
};

CLivePanel ExtDialog;

int OnInit(){

    if(!ExtDialog.Create(0, "Live Panel", 0, 20, 20, 360, 324)){
        return (INIT_FAILED);
    }

    ExtDialog.Run();

    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
    ExtDialog.Destroy(reason);
}

void OnChartEvent(  const int id,
                    const long& lparam,
                    const double& dparam,
                    const string& sparam){
    ExtDialog.ChartEvent(id, lparam, dparam, sparam);

}

bool CLivePanel::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2){
    return CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2);
}

//--- ищем только один объект - Back, и динамически меняем его цвет
//--- при помощ макросов GETRGB и XRGB
bool CLivePanel::OnDialogDragStart(){
    string prefix = Name();
    int total = ExtDialog.ControlsTotal();
    for(int i = 0; i < total; ++i){
        CWnd* obj = ExtDialog.Control(i);
        string name = obj.Name();
        if(name == prefix + "Back"){
            CPanel* panel = (CPanel*) obj;
            color clr = (color) GETRGB(XRGB(rand()%255, rand()%255, rand()%255));
            panel.ColorBorder(clr);
            ChartRedraw();
        }
    }

    return (CDialog::OnDialogDragStart());
}

//--- восстанавливаем цвет фона и рамки объектам "Border", "Back" или "Client"
bool CLivePanel::OnDialogDragEnd(){
    string prefix = Name();
    int total = ExtDialog.ControlsTotal();
    for(int i = 0; i < total; ++i){
        CWnd* obj = ExtDialog.Control(i);
        string name = obj.Name();

        if(name == prefix + "Border"){
            CPanel* panel = (CPanel*) obj;
            panel.ColorBackground(CONTROLS_DIALOG_COLOR_BG);
            panel.ColorBorder(CONTROLS_DIALOG_COLOR_BORDER_LIGHT);
            ChartRedraw();
        }
        if(name == prefix + "Back"){
            CPanel* panel = (CPanel*) obj;
            panel.ColorBackground(CONTROLS_DIALOG_COLOR_BG);
            color border = (m_panel_flag) ? CONTROLS_DIALOG_COLOR_BG : CONTROLS_DIALOG_COLOR_BORDER_DARK;
            panel.ColorBorder(border);
        }
        if(name == prefix + "Client"){
            CWndClient* wndclient = (CWndClient*) obj;
            wndclient.ColorBackground(CONTROLS_DIALOG_COLOR_CLIENT_BG);
            wndclient.ColorBorder(CONTROLS_DIALOG_COLOR_CLIENT_BORDER);
            ChartRedraw();
        }
    }
    return (CDialog::OnDialogDragEnd());
}