//+------------------------------------------------------------------+
//|                                                test_controls.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"

class Foo{
public:
   string      m_name;
   int         m_id;
   static int  s_counter;

   Foo(void){Setup("noname");};
   Foo(string name){Setup(name);};
  ~Foo(void){};

   void Setup(string name){
      m_name = name;
      s_counter++;
      m_id=s_counter;
   }
};

int Foo::s_counter = 0;

void OnStart(){
   Foo foo1;
   PrintObject(foo1);

   Foo *foo2 = new Foo("foo2");
   PrintObject(foo2);

   Foo foo_objects[5];
   PrintObjectsArray(foo_objects);

   Foo *foo_pointers[5];
   for(int i = 0; i < 5; ++i){
      foo_pointers[i] = new Foo("foo_pointer");
   }
   PrintPointersArray(foo_pointers);

   delete(foo2);

   int size = ArraySize(foo_pointers);
   for(int i = 0; i < size; ++i){
      delete(foo_pointers[i]);
   }
}

void PrintObject(Foo &object){
   Print(__FUNCTION__,": ", object.m_id," Object name= ", object.m_name);
}

void PrintObjectsArray(Foo &objects[]){
   int size = ArraySize(objects);
   for(int i = 0; i < size; ++i){
      PrintObject(objects[i]);
   }
}

void PrintPointersArray(Foo* &objects[]){
   int size = ArraySize(objects);
   for(int i = 0; i < size; ++i){
      PrintObject(objects[i]);
   }
}