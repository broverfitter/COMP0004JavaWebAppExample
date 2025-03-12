package uk.ac.ucl.model;

public class NoteNode {
    private String fpath;
    private String title;

    public NoteNode(String fpath, String title) {
        this.fpath = fpath;
        this.title = title;
    }

    public String getFpath() {
        return fpath;
    }

    public String getTitle() {
        return title;
    }
}