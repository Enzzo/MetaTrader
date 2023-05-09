//+------------------------------------------------------------------+
//|                                                test_controls.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"

class CTetrisShape{

protected:
   int         m_type;
   int         m_xpos;
   int         m_ypos;
   int         m_xsize;
   int         m_ysize;
   int         m_prev_turn;
   int         m_turn;
   int         m_right_border;

public:
   void           CTetrisShape();
   void           SetRightBorder(int border)    {m_right_border = border;}
   void           SetYPos(int ypos)             {m_ypos = ypos;}
   void           SetXPos(int xpos)             {m_xpos = xpos;}
   int            GetYPos()   const             {return m_ypos;}
   int            GetXPos()   const             {return m_xpos;}
   int            GetYSize()  const             {return m_ysize;}
   int            GetXSize()  const             {return m_xsize;}
   int            GetType()   const             {return m_type;}
   void           Left()                        {m_xpos -= SHAPE_SIZE;}
   void           Right()                       {m_xpos += SHAPE_SIZE;} 
   void           Rotate()                      {m_prev_turn = m_turn; if(++m_turn > 3) m_turn = 0;}
   virtual void   Draw()                       {return;}
   virtual bool   CheckDown(int& pad_array[]);
   virtual bool   CheckLeft(int& side_row[]);
   virtual bool   CheckRight(int& side_row[]);
};

//--- палка
class CTetrisShape1 : public CTetrisShape{

public:
   virtual void Draw(){
      int i;
      string name;

      //--- горизонтальная палка
      if(m_turn == 0 || m_turn == 2){
         for(i = 0; i < 4; ++i){
            name = SHAPE_NAME+(string)i;
            ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_xpos + i * SHAPE_SIZE);
            ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_ypos);
         }
      }
      //--- вертикальная палка
      else{
         for(i = 0; i < 4; ++i){
            name = SHAPE_NAME + (string)i;
            ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_xpos);
            ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_ypos + i * SHAPE_SIZE);
         }
      }
   }
}

class CTetrisShape6 : public CTetrisShape{

public:
   virtual void Draw(){
      int i;
      string name;
      for(i = 0; i < 2; ++i){
         name = SHAPE_NAME + (string)i;
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_xpos + i * SHAPE_SIZE);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_ypos);
      }
      for(i = 2; i < 4; ++i){
         name = SHAPE_NAME + (string)i;
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_xpos + (i-2) * SHAPE_SIZE);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_ypos + SHAPE_SIZE);
      }
   }
}
void OnStart(){
}