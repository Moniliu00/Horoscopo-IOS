//
//  DetailViewController.swift
//  Horoscopo
//
//  Created by Turno Mananas on 20/11/2026.
//



import UIKit

// MARK: - API Models

struct HoroscopeResponse: Decodable {
    let data: HoroscopeData
}

struct HoroscopeData: Decodable {
    let date: String
    let period: String
    let sign: String
    let horoscope: String
}


// MARK: - DetailViewController

class DetailViewController: UIViewController {

    var horoscope: Horoscope!
    var isFavorite = false

    @IBOutlet weak var favoriteMenuItem: UIBarButtonItem!
    @IBOutlet weak var signImageView: UIImageView!

    // New labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var horoscopeLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = horoscope.name
        navigationItem.subtitle = horoscope.dates
        signImageView.image = horoscope.sign

        // Display dates
        dateLabel.text = horoscope.dates

        // Load daily horoscope
        horoscopeLabel.text = "Loading horoscope..."
        getHoroscope()

        isFavorite = SessionManager().isFavorite(id: horoscope.id)
        setFavoriteIcon()
    }


    // MARK: - Get Horoscope from API

    func getHoroscope() {

        let urlString = "https://freehoroscopeapi.com/api/v1/get-horoscope/daily?sign=\(horoscope.id)"

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("API Error:", error.localizedDescription)

                DispatchQueue.main.async {
                    self.horoscopeLabel.text = "Unable to load horoscope."
                }
                return
            }

            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {

                DispatchQueue.main.async {
                    self.horoscopeLabel.text = "Unable to load horoscope."
                }
                return
            }

            do {
                print("API RESPONSE:")
                print(String(data: data, encoding: .utf8) ?? "No data")

                let result = try JSONDecoder().decode(
                    HoroscopeResponse.self,
                    from: data
                )

                print("HOROSCOPE:", result.data.horoscope)

                DispatchQueue.main.async {
                    self.horoscopeLabel.text = result.data.horoscope
                }

            } catch {
                print("Decoding Error:", error.localizedDescription)

                DispatchQueue.main.async {
                    self.horoscopeLabel.text = "Error loading horoscope."
                }
            }

        }.resume()
    }


    // MARK: - Favorites

    func setFavoriteIcon() {
        if isFavorite {
            favoriteMenuItem.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteMenuItem.image = UIImage(systemName: "heart")
        }
    }


    @IBAction func favoriteMenuClicked(_ sender: Any) {
        let session = SessionManager()

        if isFavorite {
            session.setFavorite(id: "")
        } else {
            session.setFavorite(id: horoscope.id)
        }

        isFavorite = !isFavorite
        setFavoriteIcon()
    }


    // MARK: - Share

    @IBAction func shareMenuClicked(_ sender: Any) {

        let text = "This is some text that I want to share."

        let textToShare = [text]

        let activityViewController = UIActivityViewController(
            activityItems: textToShare,
            applicationActivities: nil
        )

        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(
            activityViewController,
            animated: true,
            completion: nil
        )
    }
}
