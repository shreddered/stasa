module algorithms.searcher;

interface ISearcher {
    public void setInterval(in double a, in double b);
    public void search(const double eps = double.nan);
}
