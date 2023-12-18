class TimeDuration{
public:
    TimeDuration(string hint = "") : _hint(hint){
        _start = GetMicrosecondCount();
    }
    ~TimeDuration(){
        _end = GetMicrosecondCount();
        ShowResult();
    }
private:
    void ShowResult(){
        ulong duration = _end - _start;
        if(_hint != ""){
            Print("Hint: "+_hint);
        }
        Print("Duration: " + IntegerToString(duration));
        Print("Start: " + IntegerToString(_start));
        Print("End: " + IntegerToString(_end));
    }
private:
    ulong _start, _end;
    string _hint;
};

#define TIMER TimeDuration timer##__LINE__
#define TIMER_HINT(hint) TimeDuration timer##__LINE__(hint);