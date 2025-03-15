package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.UUID;

import uk.ac.ucl.model.Tree;
import uk.ac.ucl.model.DirectoryNode;

// The servlet invoked to perform a search.
// The url http://localhost:8080/runsearch.html is mapped to calling doPost on the servlet object.
// The servlet object is created automatically, you just provide the class.

@WebServlet("/saveNote")
@MultipartConfig
public class getDirectoryTree extends HttpServlet
{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    ServletContext context = getServletContext();

    String jsonFilePath = context.getRealPath("/structure.json");
    Tree tree = new Tree(jsonFilePath);
    DirectoryNode root = tree.getRoot();

    request.setAttribute("tree", root);
}
}