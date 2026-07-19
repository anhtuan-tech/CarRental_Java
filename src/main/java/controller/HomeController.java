package controller;

import dao.CarDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Car;

import java.io.IOException;
import java.util.List;

/**
 * Homepage controller: loads available car listings and forwards to homepage.jsp.
 * Accessible to both authenticated and unauthenticated users (public page).
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();
        List<Car> cars = carDAO.getTop3MostRentedCars();

        request.setAttribute("cars", cars);
        request.getRequestDispatcher("/WEB-INF/views/common/homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
