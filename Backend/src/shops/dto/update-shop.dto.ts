import { IsNotEmpty, IsString } from 'class-validator';

export class UpdateShopDto {
  @IsString({ message: 'Name must be a string.' })
  @IsNotEmpty({ message: 'Name is required.' })
  name!: string;

  @IsString({ message: 'Address must be a string.' })
  @IsNotEmpty({ message: 'Address is required.' })
  address!: string;

  @IsString({ message: 'Longitude must be a string.' })
  @IsNotEmpty({ message: 'Longitude is required.' })
  longitude!: string;

  @IsString({ message: 'Latitude must be a string.' })
  @IsNotEmpty({ message: 'Latitude is required.' })
  latitude!: string;

  @IsString({ message: 'Contact must be a string.' })
  @IsNotEmpty({ message: 'Contact is required.' })
  contact!: string;

  @IsString({ message: 'Opening time must be a string.' })
  @IsNotEmpty({ message: 'Opening time is required.' })
  openingTime!: string;

  @IsString({ message: 'Closing time must be a string.' })
  @IsNotEmpty({ message: 'Closing time is required.' })
  closingTime!: string;

  @IsString({ message: 'Description must be a string.' })
  @IsNotEmpty({ message: 'Description is required.' })
  description!: string;
}
