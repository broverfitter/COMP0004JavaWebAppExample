<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="uk.ac.ucl.model.DirectoryNode, uk.ac.ucl.model.NoteNode" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Simple Note Taking</title>
</head>
<body>
    <table border="0">
        <tr>
            <!-- Side navbar -->
            <td valign="top">
                <h2>Navigation</h2>
                <ul>
                    <%
                        DirectoryNode root = (DirectoryNode) request.getAttribute("tree");
                        if (root != null) {
                            List<Object> children = root.getChildren();
                            for (Object child : children) {
                                if (child instanceof DirectoryNode) {
                                    DirectoryNode dir = (DirectoryNode) child;
                    %>
                                    <li>Directory: <%= dir.getName() %>
                                        <ul>
                                            <%
                                                List<Object> subChildren = dir.getChildren();
                                                for (Object subChild : subChildren) {
                                                    if (subChild instanceof DirectoryNode) {
                                                        DirectoryNode subDir = (DirectoryNode) subChild;
                                            %>
                                                        <li>Directory: <%= subDir.getName() %></li>
                                            <%
                                                    } else if (subChild instanceof NoteNode) {
                                                        NoteNode note = (NoteNode) subChild;
                                            %>
                                                        <b>Note: <%= note.getTitle() %> (Path: <%= note.getFpath() %>)</b>
                                            <%
                                                    }
                                                }
                                            %>
                                        </ul>
                                    </li>
                    <%
                                } else if (child instanceof NoteNode) {
                                    NoteNode note = (NoteNode) child;
                    %>
                                    <li><a href="note?<%= note.getFpath() %>">Here Note: <%= note.getTitle() %> (Path: <%= note.getFpath() %>)</a></li>
                    <%
                                }
                            }
                        }
                    %>
                </ul>
            </td>

            <!-- Note area -->
            <td valign="top" style="padding-left:20px;">
                <h2>Write a Note</h2>
                <form action="/savenote" method="post">
                    <textarea name="note" rows="10" cols="50" placeholder='<%= request.getAttribute("content") %>'></textarea>
                    <br><br>
                    <input type="submit" value="Save Note">
                </form>
            </td>
        </tr>
    </table>
</body>
</html>