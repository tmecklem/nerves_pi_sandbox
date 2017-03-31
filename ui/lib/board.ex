defmodule Board do
  defstruct name: nil, pins: []

  def raspberry_pi do
    %Board{
      name: 'Raspberry Pi',
      pins: [
        %Pin{pin_number: 01, gpio: nil, description: "3.3v",    characteristics: [:power_3v3]},
        %Pin{pin_number: 02, gpio: nil, description: "5v",      characteristics: [:power_5v]},
        %Pin{pin_number: 03, gpio: 02,  description: "GPIO 02", characteristics: [:gpio]},
        %Pin{pin_number: 04, gpio: nil, description: "5v",      characteristics: [:power_5v]},
        %Pin{pin_number: 05, gpio: 03,  description: "GPIO 03", characteristics: [:gpio]},
        %Pin{pin_number: 06, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 07, gpio: 04,  description: "GPIO 04", characteristics: [:gpio]},
        %Pin{pin_number: 08, gpio: 14,  description: "GPIO 14", characteristics: [:gpio]},
        %Pin{pin_number: 09, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 10, gpio: 15,  description: "GPIO 15", characteristics: [:gpio]},
        %Pin{pin_number: 11, gpio: 17,  description: "GPIO 17", characteristics: [:gpio]},
        %Pin{pin_number: 12, gpio: 18,  description: "GPIO 18", characteristics: [:gpio]},
        %Pin{pin_number: 13, gpio: 27,  description: "GPIO 27", characteristics: [:gpio]},
        %Pin{pin_number: 14, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 15, gpio: 22,  description: "GPIO 22", characteristics: [:gpio]},
        %Pin{pin_number: 16, gpio: 23,  description: "GPIO 23", characteristics: [:gpio]},
        %Pin{pin_number: 17, gpio: nil, description: "3.3v",    characteristics: [:power_3v3]},
        %Pin{pin_number: 18, gpio: 24,  description: "GPIO 24", characteristics: [:gpio]},
        %Pin{pin_number: 19, gpio: 10,  description: "GPIO 10", characteristics: [:gpio]},
        %Pin{pin_number: 20, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 21, gpio: 09,  description: "GPIO 09", characteristics: [:gpio]},
        %Pin{pin_number: 22, gpio: 25,  description: "GPIO 25", characteristics: [:gpio]},
        %Pin{pin_number: 23, gpio: 11,  description: "GPIO 11", characteristics: [:gpio]},
        %Pin{pin_number: 24, gpio: 08,  description: "GPIO 08", characteristics: [:gpio]},
        %Pin{pin_number: 25, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 26, gpio: 07,  description: "GPIO 07", characteristics: [:gpio]},
        %Pin{pin_number: 27, gpio: nil, description: "ID_SD",   characteristics: [:gpio]},
        %Pin{pin_number: 28, gpio: nil, description: "ID_SC",   characteristics: [:gpio]},
        %Pin{pin_number: 29, gpio: 05,  description: "GPIO 05", characteristics: [:gpio]},
        %Pin{pin_number: 30, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 31, gpio: 06,  description: "GPIO 06", characteristics: [:gpio]},
        %Pin{pin_number: 32, gpio: 12,  description: "GPIO 12", characteristics: [:gpio]},
        %Pin{pin_number: 33, gpio: 13,  description: "GPIO 13", characteristics: [:gpio]},
        %Pin{pin_number: 34, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 35, gpio: 19,  description: "GPIO 19", characteristics: [:gpio]},
        %Pin{pin_number: 36, gpio: 16,  description: "GPIO 16", characteristics: [:gpio]},
        %Pin{pin_number: 37, gpio: 26,  description: "GPIO 26", characteristics: [:gpio]},
        %Pin{pin_number: 38, gpio: 20,  description: "GPIO 20", characteristics: [:gpio]},
        %Pin{pin_number: 39, gpio: nil, description: "Ground",  characteristics: [:ground]},
        %Pin{pin_number: 40, gpio: 21,  description: "GPIO 21", characteristics: [:gpio]},
      ]
    }
  end
end
