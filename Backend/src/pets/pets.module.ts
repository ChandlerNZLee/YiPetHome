import { Module } from '@nestjs/common';

import { PetsController } from './pets.controller';
import { PetsService } from './pets.service';
import { PetGroomsController } from './pet-grooms/pet-grooms.controller';
import { PetGroomsService } from './pet-grooms/pet-grooms.service';
import { PetVaccinesController } from './pet-vaccines/pet-vaccines.controller';
import { PetVaccinesService } from './pet-vaccines/pet-vaccines.service';
import { PetWeightsController } from './pet-weights/pet-weights.controller';
import { PetWeightsService } from './pet-weights/pet-weights.service';

@Module({
  controllers: [PetsController, PetGroomsController, PetVaccinesController, PetWeightsController],
  providers: [PetsService, PetGroomsService, PetVaccinesService, PetWeightsService],
  exports: [PetsService, PetGroomsService, PetVaccinesService, PetWeightsService],
})
export class PetsModule {}
