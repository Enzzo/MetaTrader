class TimeDuration{
public:
    TimeDuration(){
        _start = GetMicrosecondCount();
    }
    ~TimeDuration(){
        _end = GetMicrosecondCount();
        ShowResult();
    }
private:
    void ShowResult(){
        ulong duration = _end - _start;
        Print("Duration: " + IntegerToString(duration));
        Print("Start: " + IntegerToString(_start));
        Print("End: " + IntegerToString(_end));
    }
private:
    ulong _start, _end;
};

#define TIMER TimeDuration timer##__LINE__