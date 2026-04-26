package main

import (
	"log"

	"github.com/joho/godotenv"
	"github.com/leovern123/mycatalog-be/config"
	"github.com/leovern123/mycatalog-be/models"
)

func main() {
	godotenv.Load()
	config.InitDatabase()

	products := []models.Product{
		{
			Name: "Tenda Dome 2 Orang",
			Price: 350000,
			Category: "Tenda",
			Stock: 10,
			Description: "Tenda ringan untuk 2 orang, waterproof",
			ImageURL: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
		},
		{
			Name: "Carrier 60L",
			Price: 450000,
			Category: "Carrier",
			Stock: 5,
			Description: "Tas gunung kapasitas besar untuk hiking",
			ImageURL: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
		},
		{
			Name: "Sepatu Hiking Waterproof",
			Price: 600000,
			Category: "Sepatu",
			Stock: 8,
			Description: "Sepatu gunung anti air dan nyaman",
			ImageURL: "https://images.unsplash.com/photo-1528701800489-20be3c0e9d1f",
		},
		{
			Name: "Jaket Gunung Windproof",
			Price: 250000,
			Category: "Jaket",
			Stock: 15,
			Description: "Jaket tahan angin cocok untuk pendakian",
			ImageURL: "https://images.unsplash.com/photo-1520975661595-6453be3f7070",
		},
		{
			Name: "Sleeping Bag Outdoor",
			Price: 200000,
			Category: "Tenda",
			Stock: 20,
			Description: "Sleeping bag hangat untuk camping",
			ImageURL: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
		},
	}

	for _, p := range products {
		config.DB.Create(&p)
	}
	log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}
