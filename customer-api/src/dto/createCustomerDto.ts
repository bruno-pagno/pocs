import { IsString, IsNotEmpty, IsNumber } from 'class-validator';

export class CreateCustomerDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsNumber()
  @IsNotEmpty()
  document: number;
}
