import { IsNotEmpty, IsString } from 'class-validator';

export class CreateAddressDto {
  @IsString({ message: 'Province must be a string.' })
  @IsNotEmpty({ message: 'Province is required.' })
  province!: string;

  @IsString({ message: 'City must be a string.' })
  @IsNotEmpty({ message: 'City is required.' })
  city!: string;

  @IsString({ message: 'Details must be a string.' })
  @IsNotEmpty({ message: 'Details is required.' })
  details!: string;

  @IsString({ message: 'Mobile must be a string.' })
  @IsNotEmpty({ message: 'Mobile is required.' })
  mobile!: string;

  @IsString({ message: 'Postcode must be a string.' })
  @IsNotEmpty({ message: 'Postcode is required.' })
  postcode!: string;

  @IsString({ message: 'Contact must be a string.' })
  @IsNotEmpty({ message: 'Contact is required.' })
  contact!: string;

  @IsString({ message: 'Email must be a string.' })
  @IsNotEmpty({ message: 'Email is required.' })
  email!: string;

  @IsString({ message: 'Longitude must be a string.' })
  @IsNotEmpty({ message: 'Longitude is required.' })
  longitude!: string;

  @IsString({ message: 'Latitude must be a string.' })
  @IsNotEmpty({ message: 'Latitude is required.' })
  latitude!: string;
}
