package uk.ac.ucl.model;

public class NoteNode {
    private String fname;
    private String title;
    private String path;

    public NoteNode(String fname, String title, String path) {
        this.fname = fname;
        this.title = title;
        this.path = path;
    }

    public String getFname() {
        return fname;
    }

    public String getTitle() {
        return title;
    }

    public String getPath() {
        return path;
    }
}