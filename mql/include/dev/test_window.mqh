class Window;

class Glyph{
public:
    void Draw(Window*){};
};

class Window{
public:
    virtual void Redraw() {if(_glyph){_glyph->Draw();}};
    virtual void Raise() = 0;
    virtual void Lower() = 0;
    virtual void Iconify() = 0;
    virtual void Deiconify() = 0;

    virtual void DrawLine() = 0;
    virtual void DrwRect() = 0;
    virtual void DrawPolygon() = 0;
    virtual void DrawText() = 0;

private:
    Glyph* _glyph;
};



class ApplicationWindow : public Window{

};

class IconWindow : public Window{
public:
    virtual void Iconify() override{};
};

class DialogWindow : public Window{

};